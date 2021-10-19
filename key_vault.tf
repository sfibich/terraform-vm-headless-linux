data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "vm_kv" {
  name                        = "${var.prefix}-kv-${random_string.suffix.id}"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "premium"
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true
  tags                        = local.main_tags
}

resource "azurerm_key_vault_key" "vm_kv" {
  name         = "des-example-key"
  key_vault_id = azurerm_key_vault.vm_kv.id
  key_type     = "RSA"
  key_size     = 2048

  depends_on = [
    azurerm_key_vault_access_policy.example-user
  ]

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_disk_encryption_set" "vm" {
  name                = "des"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  key_vault_key_id    = azurerm_key_vault_key.vm_kv.id

  identity {
    type = "SystemAssigned"
  }
  tags = local.main_tags
}

resource "azurerm_key_vault_access_policy" "example-disk" {
  key_vault_id = azurerm_key_vault.vm_kv.id

  tenant_id = azurerm_disk_encryption_set.vm.identity.0.tenant_id
  object_id = azurerm_disk_encryption_set.vm.identity.0.principal_id

  key_permissions = [
    "Get",
    "WrapKey",
    "UnwrapKey"
  ]
}

resource "azurerm_key_vault_access_policy" "example-user" {
  key_vault_id = azurerm_key_vault.vm_kv.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
    "get",
    "create",
    "delete"
  ]
}
