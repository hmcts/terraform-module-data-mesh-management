provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias           = "hub"
  subscription_id = var.hub_subscription_id
}
