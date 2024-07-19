terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }

  # backend "azurerm" {
  #   resource_group_name  = "rg-cloudresumeapi"
  #   storage_account_name = "stcloudresumeapi"
  #   container_name       = "stcontainercloudresumeapi"
  #   key                  = "dev.terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "rg-cloudresumeapi"
  location = var.location
  tags = {
    environment = "dev"
    source      = "terraform"
  }
}

output "resourcegroup_name" {
  value       = azurerm_resource_group.main.name
  sensitive   = false
  description = "Prints the name of the resource group"
}