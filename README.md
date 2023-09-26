# terraform-module-data-management-zone
Terraform module for deploying a data management zone to Azure. Based off of [Microsoft's Bicep implementation](https://github.com/Azure/data-management-zone) utilising existing Terraform modules and integrating with shared infrastructure to reduce cost and duplication.

## Example

_COMING SOON_
```hcl
module "todo_resource_name" {
  source = "git@github.com:hmcts/terraform-module-data-management-zone?ref=main"
  ...
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.74.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.74.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault) | git@github.com:hmcts/cnp-module-key-vault | master |
| <a name="module_vnet_peer_hub"></a> [vnet\_peer\_hub](#module\_vnet\_peer\_hub) | git@github.com:hmcts/terraform-module-vnet-peering | master |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_access_policy.purview](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_private_endpoint.kv_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.purview_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.synapse_private_link_hub_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_purview_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/purview_account) | resource |
| [azurerm_resource_group.new](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_route.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_synapse_private_link_hub.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_private_link_hub) | resource |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.existing](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_subnets"></a> [additional\_subnets](#input\_additional\_subnets) | This module by default deploys a 'services' subnet with the address space of the virtual network. If you need additional subnets, you can specify them here. | <pre>map(object({<br>    address_prefixes  = list(string),<br>    service_endpoints = optional(list(string), []),<br>    delegations = optional(map(object({<br>      service_name = string,<br>      actions      = optional(list(string), [])<br>    })))<br>  }))</pre> | `{}` | no |
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | The address space covered by the virtual network. | `list(string)` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tag to be applied to resources | `map(string)` | n/a | yes |
| <a name="input_create_role_assignments"></a> [create\_role\_assignments](#input\_create\_role\_assignments) | Whether to create role assignments for the identity, this requires higher privileges. Defaults to true | `bool` | `true` | no |
| <a name="input_default_route_next_hop_ip"></a> [default\_route\_next\_hop\_ip](#input\_default\_route\_next\_hop\_ip) | IP address of the next hop for the default route, this will usually be the private ip config of the Palo Load Balancer. | `string` | n/a | yes |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | DNS servers to set as the default for the virtual network. | `list(string)` | `[]` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment value | `string` | n/a | yes |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | Name of existing resource group to deploy resources into | `string` | `null` | no |
| <a name="input_hub_resource_group_name"></a> [hub\_resource\_group\_name](#input\_hub\_resource\_group\_name) | The name of the resource group containing the HUB virtual network. | `string` | n/a | yes |
| <a name="input_hub_vnet_name"></a> [hub\_vnet\_name](#input\_hub\_vnet\_name) | The name of the HUB virtual network. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Target Azure location to deploy the resource | `string` | `"UK South"` | no |
| <a name="input_name"></a> [name](#input\_name) | The default name will be data-mgmt+env, you can override the data-mgmt part by setting this | `string` | `null` | no |
| <a name="input_services_subnet_address_space"></a> [services\_subnet\_address\_space](#input\_services\_subnet\_address\_space) | The address space for the services subnet. This is only used if you are specifying additional subnets. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | The ID of the key vault deployed for the data managaement zone. |
| <a name="output_location"></a> [location](#output\_location) | The Azure region the data management zone has been deployed to. |
| <a name="output_purview_id"></a> [purview\_id](#output\_purview\_id) | The ID of the purview account deployed for the data managaement zone. |
| <a name="output_purview_managed_event_hub_id"></a> [purview\_managed\_event\_hub\_id](#output\_purview\_managed\_event\_hub\_id) | The ID of the purview managed event hub deployed for the data managaement zone. |
| <a name="output_purview_managed_storage_id"></a> [purview\_managed\_storage\_id](#output\_purview\_managed\_storage\_id) | The ID of the purview managed storage account deployed for the data managaement zone. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group the data management zone has been deployed to. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | The IDs of the subnets deployed for the data managaement zone. |
| <a name="output_virtual_network_id"></a> [virtual\_network\_id](#output\_virtual\_network\_id) | The ID of the virtual network deployed for the data managaement zone. |
| <a name="output_virtual_network_name"></a> [virtual\_network\_name](#output\_virtual\_network\_name) | The name of the virtual network deployed for the data managaement zone. |
<!-- END_TF_DOCS -->

## Contributing

We use pre-commit hooks for validating the terraform format and maintaining the documentation automatically.
Install it with:

```shell
$ brew install pre-commit terraform-docs
$ pre-commit install
```

If you add a new hook make sure to run it against all files:
```shell
$ pre-commit run --all-files
```
