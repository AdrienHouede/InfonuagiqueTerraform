output "vm_public_ip" {
  value = azurerm_public_ip.adrien.ip_address
}

output "vm_private_ip" {
  value = azurerm_network_interface.adrien.ip_configuration[0].private_ip_address
}

output "storage_account_name" {
  value = azurerm_storage_account.adrien.name
}

output "storage_account_url" {
  value = "https://${azurerm_storage_account.adrien.name}.blob.core.windows.net"
}

output "flask_url" {
  value = "http://${azurerm_public_ip.adrien.ip_address}:5000"
}

output "resource_group_name" {
  value = azurerm_resource_group.adrien.name
}

output "account_key" {
  value     = var.account_key
  sensitive = true
}