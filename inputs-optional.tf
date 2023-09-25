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
