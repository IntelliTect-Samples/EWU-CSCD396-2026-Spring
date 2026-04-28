variable "resource_group_name" {
  type    = string
  default = "396_test"
}

variable "location" {
  type    = string
  default = "canadacentral"
}

variable "container_app_name" {
  type    = string
  default = "assignment2-container-app"
}

variable "container_image" {
  type = string
}

variable "acr_login_server" {
  type = string
}

variable "acr_username" {
  type = string
}

variable "acr_password" {
  type      = string
  sensitive = true
}