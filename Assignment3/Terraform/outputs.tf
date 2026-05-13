output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "container_app_name" {
  value = azurerm_container_app.main.name
}

output "container_app_url" {
  value = "https://${azurerm_container_app.main.latest_revision_fqdn}"
}

output "container_registry_login_server" {
  value = azurerm_container_registry.main.login_server
}

output "function_app_name" {
  value = azurerm_linux_function_app.main.name
}

output "service_bus_namespace" {
  value = azurerm_servicebus_namespace.main.name
}

output "service_bus_queue" {
  value = azurerm_servicebus_queue.messages.name
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "storage_container_name" {
  value = azurerm_storage_container.functionoutput.name
}
