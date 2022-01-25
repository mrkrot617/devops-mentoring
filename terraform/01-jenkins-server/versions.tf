terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.73"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1.0"
    }
  }

  required_version = ">= 1.1.4"
}