output "windows_function_identity_id" {
  value = azurerm_windows_function_app.function.identity[0].principal_id
}

output "windows_function_id" {
  value = azurerm_windows_function_app.function.id
}

output "windows_function_storage_account_id" {
  value = azurerm_storage_account.storage_account_function.id
}
