resource "azurerm_route_table" "this" {
  name                = "${local.name}-routetable-${var.env}"
  location            = local.location
  resource_group_name = local.resource_group
  tags                = var.common_tags
}

resource "azurerm_route" "default" {
  name                   = "default"
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.default_route_next_hop_ip
  route_table_name       = azurerm_route_table.this.name
  resource_group_name    = local.resource_group
}

resource "azurerm_network_security_group" "this" {
  name                = "${local.name}-nsg-${var.env}"
  location            = local.location
  resource_group_name = local.resource_group
  tags                = var.common_tags
}

resource "azurerm_virtual_network" "this" {
  name                = "${local.name}-vnet-${var.env}"
  location            = local.location
  resource_group_name = local.resource_group
  address_space       = var.address_space
  dns_servers         = var.dns_servers

  tags = var.common_tags
}

resource "azurerm_subnet" "this" {
  for_each             = merge(local.subnets, var.additional_subnets)
  name                 = each.key
  resource_group_name  = local.resource_group
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints

  dynamic "delegation" {
    for_each = each.value.delegations != null ? each.value.delegations : {}
    content {
      name = delegation.key
      service_delegation {
        name    = delegation.value.service_name
        actions = delegation.value.actions
      }
    }
  }
}
