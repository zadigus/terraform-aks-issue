terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.58.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "=2.9.0"
    }
  }
  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
}