output "linux_function_identity_id" {
  value = azurerm_linux_function_app.function.identity[0].principal_id
}

output "linux_function_id" {
  value = azurerm_linux_function_app.function.id
}

output "linux_function_storage_account_id" {
  value = azurerm_storage_account.storage_account_function.id
}
