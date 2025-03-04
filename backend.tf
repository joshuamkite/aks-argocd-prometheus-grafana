terraform {
  backend "azurerm" {
    # storage_account_name = var.storage_account_name
    container_name       = "tfstate"
    key                  = "terraform-azure-aks-demo/terraform.tfstate"
    resource_group_name  = "tfstate-rg"
    storage_account_name = var.storage_account_name

  }
}
