output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "container_registry_login_server" {
  description = "Login server hostname of the container registry"
  value       = azurerm_container_registry.main.login_server
}

output "container_registry_name" {
  description = "Name of the container registry"
  value       = azurerm_container_registry.main.name
}

output "container_app_fqdn" {
  description = "Stable FQDN of the Container App ingress (does not change between revisions)"
  value       = azurerm_container_app.main.ingress[0].fqdn
}

output "container_app_url" {
  description = "Stable URL of the Container App"
  value       = "https://${azurerm_container_app.main.ingress[0].fqdn}"
}
