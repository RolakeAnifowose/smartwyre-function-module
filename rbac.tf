resource "azurerm_key_vault_access_policy" "function" {
  for_each     = var.functions
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id

  object_id = azurerm_windows_function_app.new[each.key].identity[0].principal_id

  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]

  key_permissions = [
    "Get", "List", "Update", "Create", "Import", "Delete", "Backup", "Recover", "Backup", "Restore"
  ]
}

resource "azurerm_role_assignment" "app_config_data_reader_func" {
  for_each = var.functions

  scope                = var.app_config_id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_windows_function_app.new[each.key].identity[0].principal_id

}

resource "azurerm_key_vault_key" "key" {
  name         = "${local.resource_name_prefix}-vault-key"
  key_vault_id = azurerm_key_vault.functions_kv.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }
}