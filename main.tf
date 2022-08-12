##Local Variables##
locals {
  location                    = "canadacentral"
  rg_name                     = "rg-function-private-network"
  func_storage_name_lnx       = "jdsafunclinux"
  func_name_lnx               = "func-linux-jd"
  func_storage_name_win       = "jdsafuncwin"
  func_name_win               = "func-windows-jd"
}


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.7.0"
    }
  }
}

provider "azurerm" {
  features {}

}








