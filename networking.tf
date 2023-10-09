module "networking" {
  source = "github.com/hmcts/terraform-module-azure-virtual-networking?ref=main"

  env                          = var.env
  product                      = "data-landing"
  common_tags                  = var.common_tags
  component                    = "networking"
  name                         = local.name
  location                     = var.location
  existing_resource_group_name = local.resource_group

  vnets = {
    vnet = {
      address_space = var.address_space
      subnets       = merge(local.subnets, var.additional_subnets)
    }
  }

  route_tables = {
    rt = {
      subnets = keys(merge(local.subnets, var.additional_subnets))
      routes = {
        default = {
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = var.default_route_next_hop_ip
        }
      }
    }
  }

  network_security_groups = {
    nsg = {
      subnets = keys(merge(local.subnets, var.additional_subnets))
      rules   = {}
    }
  }
}

module "vnet_peer_hub" {
  source = "github.com/hmcts/terraform-module-vnet-peering?ref=feat%2Ftweak-to-enable-planning-in-a-clean-env"
  peerings = {
    source = {
      name           = "${local.name}-vnet-${var.env}-to-hub"
      vnet_id        = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${module.networking.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${module.networking.vnet_names["vnet"]}"
      vnet           = module.networking.vnet_names["vnet"]
      resource_group = module.networking.resource_group_name
    }
    target = {
      name           = "hub-to-${local.name}-vnet-${var.env}"
      vnet           = var.hub_vnet_name
      resource_group = var.hub_resource_group_name
    }
  }

  providers = {
    azurerm.initiator = azurerm
    azurerm.target    = azurerm.hub
  }
}
