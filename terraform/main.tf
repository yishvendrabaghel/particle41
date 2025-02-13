terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.65"
    }
  }
}

provider "aws" {
  access_key = "<access_key>"
  secret_key = "<secret_key>"
  region     = "us-east-1"
}