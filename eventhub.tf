resource "azurerm_eventhub_namespace" "eventhub-namespace" {
  name                = var.eventhub_name
  location            = var.location
  resource_group_name = var.eventhub_rg
  sku                 = var.eventhub_ns_sku
  tags                = var.common_tags
}

resource "azurerm_eventhub" "paas_eventhub" {
  for_each            = toset(var.paas_services)
  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.eventhub-namespace.name
  resource_group_name = azurerm_eventhub_namespace.eventhub-namespace.resource_group_name
  partition_count     = 4
  message_retention   = var.message_retention
}

resource "azurerm_eventhub_namespace_authorization_rule" "soc-eventhub-sender" {
  name                = "dlrm-eventhub-namespace-sender"
  namespace_name      = azurerm_eventhub_namespace.eventhub-namespace.name
  resource_group_name = var.eventhub_rg

  listen = false
  send   = true
  manage = false
}