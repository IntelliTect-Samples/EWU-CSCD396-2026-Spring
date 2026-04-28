variable "container_image_name" {
  description = "Full container image name"
  type        = string
}

variable "resource_group_name" {
  default = "assignment2-rg"
}

variable "location" {
  default = "westus3"
}

variable "web_app_name" {
  default = "crawford-app-unique123"
}

variable "acr_name" {
  default = "crawfordacr123"
}