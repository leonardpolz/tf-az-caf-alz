terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.103.1"
    }
  }
  backend "local" {
    path = "./connectivity.tfstate"
  }
}

