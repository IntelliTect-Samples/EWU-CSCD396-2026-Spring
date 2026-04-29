# Variables
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "assignment2-rg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "centralus"
}

variable "environment_name" {
  description = "Name of the Container Apps Environment"
  type        = string
  default     = "assignment2"
}

variable "container_app_name" {
  description = "Name of the Container App"
  type        = string
  default     = "assignment2ca"
}

variable "image_name" {
  description = "Container image to deploy"
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "container_registry_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "assignment2acrwiilke"
}