variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "assignment3-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "centralus"
}

variable "container_apps_location" {
  description = "Azure region for Container Apps resources"
  type        = string
  default     = "eastus"
}

variable "environment_name" {
  description = "Name of the Container Apps Environment"
  type        = string
  default     = "assignment3"
}

variable "container_app_name" {
  description = "Name of the Container App"
  type        = string
  default     = "assignment3ca"
}

variable "image_name" {
  description = "Container image to deploy"
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "container_registry_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "assignment3acrwiilke"
}

variable "service_bus_namespace_name" {
  description = "Name of the Service Bus namespace"
  type        = string
  default     = "assignment3-sb-wiilke"
}

variable "service_bus_queue_name" {
  description = "Name of the Service Bus queue"
  type        = string
  default     = "messages"
}

variable "function_app_name" {
  description = "Name of the Azure Function App"
  type        = string
  default     = "assignment3-func"
}

variable "function_plan_name" {
  description = "Name of the Azure Function App Service Plan"
  type        = string
  default     = "assignment3-func-plan"
}

variable "storage_account_name" {
  description = "Name of the Storage Account"
  type        = string
  default     = "assignment3storage"
}
