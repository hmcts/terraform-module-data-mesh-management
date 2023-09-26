variable "env" {
  default = "test"
}

variable "hub_subscription_id" {
  default = "fb084706-583f-4c9a-bdab-949aac66ba5c"
}

variable "hub_vnet_name" {
  default = "hmcts-hub-nonprodi"
}

variable "hub_resource_group_name" {
  default = "hmcts-hub-nonprodi"
}

variable "default_route_next_hop_ip" {
  default = "10.11.72.36/32"
}

variable "common_tags" {
  description = "Common tag to be applied to resources"
  type        = map(string)
  default     = {}
}
