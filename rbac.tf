resource "azurerm_role_assignment" "app_config_data_reader_func" {
  for_each             = var.functions
  scope                = var.app_config_id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_windows_function_app.new[each.key].identity[0].principal_id
}

resource "azurerm_role_assignment" "function_kv_secrets_user" {
  for_each             = var.functions
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_windows_function_app.new[each.key].identity[0].principal_id
}

resource "azurerm_role_assignment" "function_kv_crypto_user" {
  for_each             = var.functions
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_windows_function_app.new[each.key].identity[0].principal_id
}