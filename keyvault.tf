module "key_vault" {
  source              = "github.com/hmcts/cnp-module-key-vault?ref=fix%2Fadd-metrics-block"
  name                = "${local.name}-kv-${var.env}"
  product             = "data-mgmt-zone"
  env                 = var.env
  object_id           = data.azurerm_client_config.current.object_id
  resource_group_name = local.resource_group
  product_group_name  = local.is_prod ? "DTS Platform Operations" : "DTS Platform Operations SC" # TODO: update this to a data mgmt zone product group
  common_tags         = var.common_tags
}

resource "azurerm_private_endpoint" "kv_endpoint" {
  name                = "${local.name}-kv-endpoint-${var.env}"
  location            = local.location
  resource_group_name = local.resource_group
  subnet_id           = module.networking.subnet_ids["vnet-services"]

  private_service_connection {
    name                           = "${local.name}-kv-endpoint-connection-${var.env}"
    private_connection_resource_id = module.key_vault.key_vault_id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "endpoint-dnszonegroup"
    private_dns_zone_ids = ["/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
  }

  tags = var.common_tags
}

resource "azurerm_key_vault_access_policy" "purview" {
  key_vault_id = module.key_vault.key_vault_id
  tenant_id    = var.existing_purview_account == null ? azurerm_purview_account.this[0].identity[0].tenant_id : var.existing_purview_account.identity.tenant_id
  object_id    = var.existing_purview_account == null ? azurerm_purview_account.this[0].identity[0].principal_id : var.existing_purview_account.identity.principal_id

  secret_permissions = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
}
