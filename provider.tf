terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.11.43"
    }
  }
  backend "azurerm" {
    resource_group_name  = "arch-storage-rg"
    storage_account_name = "xcterraformgithubactions"
    container_name       = "lb-only"
    key                  = "terraform.tfstat"
  }
}

provider "volterra" {
  url          = local.f5xc_api_url
  api_p12_file = var.f5xc_api_p12_file
}