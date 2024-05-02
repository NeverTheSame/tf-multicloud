terraform {
  backend "azurerm" {
    resource_group_name   = "terraform-states"
    storage_account_name  = "terraformstatestorage"
    container_name        = "tfstatefiles"
    key                   = "prod/01-prod-projects/terraform.tfstate"
  }
}
