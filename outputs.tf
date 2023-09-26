output "resource_group_name" {
  value       = local.resource_group
  description = "The name of the resource group the data management zone has been deployed to."
}

output "location" {
  value       = local.location
  description = "The Azure region the data management zone has been deployed to."
}

output "virtual_network_name" {
  value       = azurerm_virtual_network.this.name
  description = "The name of the virtual network deployed for the data managaement zone."
}

output "virtual_network_id" {
  value       = azurerm_virtual_network.this.id
  description = "The ID of the virtual network deployed for the data managaement zone."
}

output "subnet_ids" {
  value       = values(azurerm_subnet.this)[*].id
  description = "The IDs of the subnets deployed for the data managaement zone."
}

output "key_vault_id" {
  value       = module.key_vault.key_vault_id
  description = "The ID of the key vault deployed for the data managaement zone."
}

output "purview_id" {
  value       = azurerm_purview_account.this[0].id
  description = "The ID of the purview account deployed for the data managaement zone."
}

output "purview_managed_storage_id" {
  value       = azurerm_purview_account.this[0].managed_resources[0].storage_account_id
  description = "The ID of the purview managed storage account deployed for the data managaement zone."
}

output "purview_managed_event_hub_id" {
  value       = azurerm_purview_account.this[0].managed_resources[0].event_hub_namespace_id
  description = "The ID of the purview managed event hub deployed for the data managaement zone."
}
