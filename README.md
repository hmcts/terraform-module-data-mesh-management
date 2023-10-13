# terraform-module-data-management-zone
Terraform module for deploying a data management zone to Azure. Based off of [Microsoft's Bicep implementation](https://github.com/Azure/data-management-zone) utilising existing Terraform modules and integrating with shared infrastructure to reduce cost and duplication.

## Example deploying a new Purview account

```hcl
module "data_mgmt_zone" {
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
}
```

## Example deploying referencing an existing Purview account

```hcl
module "data_mgmt_zone" {
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
    resource_id                    = "/subscriptions/a8140a9e-f1b0-481f-a4de-09e2ee23f7ab/resourceGroups/mi-sbox-rg/providers/Microsoft.Purview/accounts/mi-purview-sbox"
    managed_storage_account_id     = "/subscriptions/a8140a9e-f1b0-481f-a4de-09e2ee23f7ab/resourceGroups/managed-rg-mi-purview-sbox/providers/Microsoft.Storage/storageAccounts/scanuksouthlyehlok"
    identity = {
      principal_id = "487b08af-d9de-4ca3-8cbe-7a232a0e8858"
      tenant_id    = "531ff96d-0ae9-462a-8d2d-bec7c0b42082"
    }
  }
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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.74.0 |
| <a name="provider_azurerm.ssptl"></a> [azurerm.ssptl](#provider\_azurerm.ssptl) | >= 3.74.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_key_vault"></a> [key\_vault](#module\_key\_vault) | github.com/hmcts/cnp-module-key-vault | fix%2Fremove-creator-access-policy |
| <a name="module_networking"></a> [networking](#module\_networking) | github.com/hmcts/terraform-module-azure-virtual-networking | main |
| <a name="module_vnet_peer_hub"></a> [vnet\_peer\_hub](#module\_vnet\_peer\_hub) | github.com/hmcts/terraform-module-vnet-peering | feat%2Ftweak-to-enable-planning-in-a-clean-env |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_access_policy.purview](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_private_endpoint.kv_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.purview_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.synapse_private_link_hub_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_purview_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/purview_account) | resource |
| [azurerm_resource_group.new](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_synapse_private_link_hub.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/synapse_private_link_hub) | resource |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.existing](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.ssptl-00](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.ssptl-01](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
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
| <a name="input_existing_purview_account"></a> [existing\_purview\_account](#input\_existing\_purview\_account) | Details of an existing purview account to use, if not specified a new one will be created. | <pre>object({<br>    resource_id                              = string<br>    managed_storage_account_id               = optional(string)<br>    managed_event_hub_namespace_id           = optional(string)<br>    self_hosted_integration_runtime_auth_key = optional(string)<br>    identity = object({<br>      principal_id = string<br>      tenant_id    = string<br>    })<br>  })</pre> | `null` | no |
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
| <a name="output_virtual_network_ids"></a> [virtual\_network\_ids](#output\_virtual\_network\_ids) | The ID of the virtual network deployed for the data managaement zone. |
| <a name="output_virtual_network_names"></a> [virtual\_network\_names](#output\_virtual\_network\_names) | The name of the virtual network deployed for the data managaement zone. |
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
