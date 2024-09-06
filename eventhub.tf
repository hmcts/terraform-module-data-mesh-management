locals {
  services_map = var.env == "stg" ? {} : tomap({ for s in var.services : s => s })
}

resource "azurerm_eventhub_namespace" "eventhub-namespace" {
  count               = var.env == "stg" ? 0 : 1
  name                = "${var.env}-dlrm-eventhub-ns"
  location            = var.location
  resource_group_name = local.resource_group
  sku                 = var.eventhub_ns_sku
  tags                = var.common_tags
}

resource "azurerm_eventhub" "eventhub" {
  for_each            = local.services_map
  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.eventhub-namespace.name
  resource_group_name = local.resource_group
  partition_count     = 4
  message_retention   = var.message_retention
}

resource "azurerm_eventhub_namespace_authorization_rule" "eventhub-sender" {
  count               = var.env == "stg" ? 0 : 1
  name                = "dlrm-eventhub-namespace-sender"
  namespace_name      = azurerm_eventhub_namespace.eventhub-namespace.name
  resource_group_name = local.resource_group

  listen = false
  send   = true
  manage = false
}
