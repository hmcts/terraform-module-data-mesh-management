data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

locals {
  is_prod           = length(regexall(".*(prod).*", var.env)) > 0
  is_sbox           = length(regexall(".*(s?box).*", var.env)) > 0
  name              = var.name != null ? var.name : "data-mgmt"
  resource_group    = var.existing_resource_group_name == null ? azurerm_resource_group.new[0].name : data.azurerm_resource_group.existing[0].name
  resource_group_id = var.existing_resource_group_name == null ? azurerm_resource_group.new[0].id : data.azurerm_resource_group.existing[0].id
  location          = var.existing_resource_group_name == null ? azurerm_resource_group.new[0].location : data.azurerm_resource_group.existing[0].location
  subnets = {
    services = {
      address_prefixes  = var.services_subnet_address_space != null ? var.services_subnet_address_space : var.address_space
      service_endpoints = []
      delegations       = null
    }
  }
  merged_subnets = merge(local.subnets, var.additional_subnets)
  subnet_keys    = formatlist("vnet-%s", keys(local.merged_subnets))
  # TODO: This needs to be created
  purview_privatelink_dns_zone_id = "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.purview.azure.com"

  purview_private_endpoints = {
    account = {
      resource_id         = var.existing_purview_account == null ? azurerm_purview_account.this[0].id : var.existing_purview_account.resource_id
      private_dns_zone_id = local.purview_privatelink_dns_zone_id
    }
    portal = {
      resource_id         = var.existing_purview_account == null ? azurerm_purview_account.this[0].id : var.existing_purview_account.resource_id
      private_dns_zone_id = local.purview_privatelink_dns_zone_id
    }
    blob = {
      resource_id         = var.existing_purview_account == null ? azurerm_purview_account.this[0].managed_resources[0].storage_account_id : var.existing_purview_account.managed_storage_account_id
      private_dns_zone_id = "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
    }
    queue = {
      resource_id         = var.existing_purview_account == null ? azurerm_purview_account.this[0].managed_resources[0].storage_account_id : var.existing_purview_account.managed_storage_account_id
      private_dns_zone_id = "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.queue.core.windows.net"
    }
    namespace = {
      resource_id         = var.existing_purview_account == null ? azurerm_purview_account.this[0].managed_resources[0].event_hub_namespace_id : var.existing_purview_account.managed_event_hub_namespace_id
      private_dns_zone_id = "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.servicebus.windows.net"
    }
  }
  non_null_purview_private_endpoints = { for key, value in local.purview_private_endpoints : key => value if value.resource_id != null }
}
