variable "existing_resource_group_name" {
  description = "Name of existing resource group to deploy resources into"
  type        = string
  default     = null
}

variable "location" {
  description = "Target Azure location to deploy the resource"
  type        = string
  default     = "UK South"
}

variable "name" {
  description = "The default name will be data-mgmt+env, you can override the data-mgmt part by setting this"
  type        = string
  default     = null
}

variable "dns_servers" {
  description = "DNS servers to set as the default for the virtual network."
  type        = list(string)
  default     = []
}

variable "additional_subnets" {
  description = "This module by default deploys a 'services' subnet with the address space of the virtual network. If you need additional subnets, you can specify them here."
  type = map(object({
    address_prefixes  = list(string),
    service_endpoints = optional(list(string), []),
    delegations = optional(map(object({
      service_name = string,
      actions      = optional(list(string), [])
    })))
  }))
  default = {}
}

variable "services_subnet_address_space" {
  description = "The address space for the services subnet. This is only used if you are specifying additional subnets."
  type        = list(string)
  default     = null
}

variable "create_role_assignments" {
  description = "Whether to create role assignments for the identity, this requires higher privileges. Defaults to true"
  type        = bool
  default     = true
}

variable "existing_purview_account" {
  description = "Details of an existing purview account to use, if not specified a new one will be created."
  type = object({
    resource_id                              = string
    managed_storage_account_id               = optional(string)
    managed_event_hub_namespace_id           = optional(string)
    self_hosted_integration_runtime_auth_key = optional(string)
    identity = object({
      principal_id = string
      tenant_id    = string
    })
  })
  default = null
}

variable "additional_kv_access_policies" {
  description = "Additional access policies to add to the key vault"
  type = map(object({
    secret_permissions      = optional(list(string), [])
    certificate_permissions = optional(list(string), [])
    key_permissions         = optional(list(string), [])
  }))
  default = {}
}

variable "zone_redundant" {
  type        = bool
  default     = false
  description = "Allows you to make eventhub namespace zone reduntdant"
}
