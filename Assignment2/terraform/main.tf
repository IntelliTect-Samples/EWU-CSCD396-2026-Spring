terraform {
  required_version = ">= 1.5.0"

  backend "azurerm" {
    resource_group_name  = "396_test"
    storage_account_name = "396a1"
    container_name       = "tfstate"
    key                  = "assignment2.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "98ef8437-66f2-4a03-9d1a-cf7057d27d9c"
}

data "azurerm_container_app_environment" "env" {
  name                = "cscd396-container-app-env"
  resource_group_name = var.resource_group_name
}

resource "azurerm_container_app" "app" {
  name                         = var.container_app_name
  container_app_environment_id = data.azurerm_container_app_environment.env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  registry {
    server               = var.acr_login_server
    username             = var.acr_username
    password_secret_name = "acr-password"
  }

  secret {
    name  = "acr-password"
    value = var.acr_password
  }

  ingress {
    external_enabled = true
    target_port      = 80

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    container {
      name   = "webapp"
      image  = var.container_image
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}