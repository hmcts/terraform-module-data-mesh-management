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
  default     = ""
}
