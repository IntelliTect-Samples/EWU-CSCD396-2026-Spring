variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-assignment2-crawford"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "environment_name" {
  description = "Name of the Container Apps Environment"
  type        = string
  default     = "env-assignment2-crawford"
}

variable "container_app_name" {
  description = "Name of the Container App"
  type        = string
  default     = "ca-assignment2-crawford"
}

variable "container_image_name" {
  description = "Full container image name passed from GitHub Actions"
  type        = string
}