data "azurerm_subscription" "current" {
}

locals {
  name = var.name != "" ? var.name : "data-mgmt-${var.env}"
}
