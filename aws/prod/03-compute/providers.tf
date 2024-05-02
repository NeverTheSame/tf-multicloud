terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  region                   = "us-east-2"
  profile                  = "prod-admin-mfa"

  default_tags {
    tags = {
      Environment = "Prod"
      ManagedBy   = "Terraform"
    }
  }
}