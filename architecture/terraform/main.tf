terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

module "s3" {
  source = "./modules/s3"
}

module "ecs_fargate" {
  source = "./modules/ecs_fargate"
}

module "datadog_monitors" {
  source = "./modules/datadog"
}
