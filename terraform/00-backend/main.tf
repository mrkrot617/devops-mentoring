provider "aws" {
  profile = var.aws_provider_profile
  region  = local.aws_region
}

locals {
  aws_region = "us-east-1"
}