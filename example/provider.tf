terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.57.1"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      Name      = "aws-iam-advisor"
      CreatedBy = "Kotechnolgies"
    }
  }
}