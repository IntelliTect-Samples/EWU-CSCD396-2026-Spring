terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "assignment2-rg"
    storage_account_name = "assignment2sawiilke"
    container_name       = "tfstate"
    key                  = "assignment3.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "main" {
  name                     = "${var.storage_account_name}${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "functionoutput" {
  name                  = "functionoutput"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_container_registry" "main" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_service_plan" "function" {
  name                = var.function_plan_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

data "azurerm_container_app_environment" "main" {
  name                = var.environment_name
  resource_group_name = var.environment_resource_group_name
}

resource "azurerm_container_app" "main" {
  name                         = var.container_app_name
  container_app_environment_id = data.azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  identity {
    type = "SystemAssigned"
  }

  secret {
    name  = "acr-password"
    value = azurerm_container_registry.main.admin_password
  }

  secret {
    name  = "servicebus-connection-string"
    value = azurerm_servicebus_namespace_authorization_rule.assignment3.primary_connection_string
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
      env {
        name        = "SERVICEBUS_CONNECTION_STRING"
        secret_name = "servicebus-connection-string"
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

resource "azurerm_servicebus_namespace_authorization_rule" "assignment3" {
  name         = "assignment3"
  namespace_id = azurerm_servicebus_namespace.main.id

  listen = true
  send   = true
  manage = false
}

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
      dotnet_version              = "8.0"
      use_dotnet_isolated_runtime = true
    }
  }
  app_settings = {
    "AzureWebJobsStorage"                           = azurerm_storage_account.main.primary_connection_string
    "FUNCTIONS_WORKER_RUNTIME"                      = "dotnet-isolated"
    "ServiceBusConnection__fullyQualifiedNamespace" = "${azurerm_servicebus_namespace.main.name}.servicebus.windows.net"
    "ServiceBusConnection"                          = azurerm_servicebus_namespace_authorization_rule.assignment3.primary_connection_string
    "ServiceBusQueueName"                           = azurerm_servicebus_queue.messages.name
    "OutputContainer"                               = azurerm_storage_container.functionoutput.name
    "StorageConnectionString"                       = azurerm_storage_account.main.primary_connection_string
    "StorageAccountBlobEndpoint"                    = "https://${azurerm_storage_account.main.name}.blob.core.windows.net/"
  }
}
