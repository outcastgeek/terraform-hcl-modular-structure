
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.20.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.15.0"
    }
    googlebeta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.15.0" # for enabling private services access
    }
  }
}
