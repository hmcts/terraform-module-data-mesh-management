module "data_mgmt_zone" {
  source = "../."

  providers = {
    azurerm       = azurerm,
    azurerm.hub   = azurerm.hub
    azurerm.ssptl = azurerm.ssptl
  }

  env                       = var.env
  common_tags               = var.common_tags
  default_route_next_hop_ip = var.default_route_next_hop_ip
  address_space             = ["10.100.100.0/24"]
  hub_vnet_name             = var.hub_vnet_name
  hub_resource_group_name   = var.hub_resource_group_name
}
