terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.12.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.60.1"
    }
  }
}

# Configured via Environment Variables
provider "okta" {}
provider "tfe" {}
