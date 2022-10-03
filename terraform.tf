terraform {

  required_version = ">=1.3.0"

  required_providers {

      azurerm = {
        source = hashicorp/azurerm
        version = ">= 3.14.0"
      }

      azapi = {
        source = azure/azapi
        version = ">=0.5.0"
      }

      kubernetes = {
        source = hashicorp/kubernetes
        version = ">=2.11.0"
      }
  }
}