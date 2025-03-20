output "vm_public_ip" {
  value = azurerm_linux_virtual_machine.adrien.public_ip_address
}

output "storage_account_name" {
  value = azurerm_storage_account.adrien.name
}
