terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.117.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}



