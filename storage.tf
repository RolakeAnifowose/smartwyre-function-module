resource "azurerm_storage_account" "func_storage" {
  for_each                         = var.functions
  name                             = lower(substr(replace(format("myfunc%s", each.key), "-", ""), 0, 24))
  location                         = var.resource_group.location
  resource_group_name              = var.resource_group.name
  account_tier                     = "Standard"
  account_replication_type         = "LRS"
  allow_nested_items_to_be_public  = false
  min_tls_version                  = "TLS1_2"
  cross_tenant_replication_enabled = true
  access_tier                      = "Hot"

  blob_properties {
    last_access_time_enabled = true
    delete_retention_policy {
      days = 5
    }

    container_delete_retention_policy {
      days = 5
    }
  }

  identity {
    type         = "UserAssigned, SystemAssigned"
    identity_ids = [var.identity_id]
  }

  customer_managed_key {
    key_vault_key_id          = var.key_id
    user_assigned_identity_id = var.identity_id
  }

  tags = var.tags
}