terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.application_name}"
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