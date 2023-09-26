module "data_mgmt_zone_existing_purview" {
  source = "../."

  providers = {
    azurerm     = azurerm,
    azurerm.hub = azurerm.hub
  }

  env                       = var.env
  common_tags               = var.common_tags
  default_route_next_hop_ip = var.default_route_next_hop_ip
  address_space             = ["10.100.100.0/24"]
  hub_vnet_name             = var.hub_vnet_name
  hub_resource_group_name   = var.hub_resource_group_name

  existing_purview_account = {
    resource_id                = "/subscriptions/a8140a9e-f1b0-481f-a4de-09e2ee23f7ab/resourceGroups/mi-sbox-rg/providers/Microsoft.Purview/accounts/mi-purview-sbox"
    managed_storage_account_id = "/subscriptions/a8140a9e-f1b0-481f-a4de-09e2ee23f7ab/resourceGroups/managed-rg-mi-purview-sbox/providers/Microsoft.Storage/storageAccounts/scanuksouthlyehlok"
    identity = {
      principal_id = "487b08af-d9de-4ca3-8cbe-7a232a0e8858"
      tenant_id    = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
    }
  }
}
