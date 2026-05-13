terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "assignment2-rg"
    storage_account_name = "assignment2sawiilke"
    container_name       = "tfstate"
    key                  = "assignment2.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Random string for unique resource names
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Storage Account
resource "azurerm_storage_account" "main" {
  name                     = "${var.storage_account_name}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Storage Container for function output
resource "azurerm_storage_container" "functionoutput" {
  name                  = "functionoutput"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# ACR
resource "azurerm_container_registry" "main" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true
}

# App Service Plan for Function
resource "azurerm_service_plan" "function" {
  name                = var.function_plan_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

# Log Analytics Workspace (required for Container Apps Environment)
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${var.environment_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Container Apps Environment
resource "azurerm_container_app_environment" "main" {
  name                       = var.environment_name
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
}

# Container App
resource "azurerm_container_app" "main" {
  name                         = var.container_app_name
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  identity {
    type = "SystemAssigned"
  }

  secret {
    name  = "acr-password"
    value = azurerm_container_registry.main.admin_password
  }

  registry {
    server               = azurerm_container_registry.main.login_server
    username             = azurerm_container_registry.main.admin_username
    password_secret_name = "acr-password"
  }

  template {
    container {
      name   = "main-container"
      image  = var.image_name
      cpu    = 0.25
      memory = "0.5Gi"
      env {
        name  = "SERVICEBUS_NAMESPACE"
        value = azurerm_servicebus_namespace.main.name
      }
      env {
        name  = "SERVICEBUS_QUEUE"
        value = azurerm_servicebus_queue.messages.name
      }
    }

    min_replicas = 1
    max_replicas = 3
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 8080
    transport                  = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

resource "azurerm_servicebus_namespace" "main" {
  name                = var.service_bus_namespace_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"
}

resource "azurerm_servicebus_queue" "messages" {
  name         = var.service_bus_queue_name
  namespace_id = azurerm_servicebus_namespace.main.id
}

# Azure Function App (Linux, Managed Identity)
resource "azurerm_linux_function_app" "main" {
  name                       = "${var.function_app_name}-${random_string.suffix.result}"
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  service_plan_id            = azurerm_service_plan.function.id
  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key
  identity {
    type = "SystemAssigned"
  }
  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
  }
  app_settings = {
    "AzureWebJobsStorage" = azurerm_storage_account.main.primary_connection_string
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet"
    "ServiceBusConnection__fullyQualifiedNamespace" = azurerm_servicebus_namespace.main.name
    "ServiceBusQueueName" = azurerm_servicebus_queue.messages.name
    "OutputContainer" = azurerm_storage_container.functionoutput.name
    "STORAGE_ACCOUNT_URL" = "https://${azurerm_storage_account.main.name}.blob.core.windows.net"
  }
}

# Grant Function App access to Storage Account
resource "azurerm_role_assignment" "function_storage_blob_contributor" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_function_app.main.identity[0].principal_id
}

# Grant Container App access to Service Bus (Sender)
resource "azurerm_role_assignment" "containerapp_servicebus_sender" {
  scope                = azurerm_servicebus_namespace.main.id
  role_definition_name = "Azure Service Bus Data Sender"
  principal_id         = azurerm_container_app.main.identity.principal_id
}