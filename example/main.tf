terraform {
  required_providers {
    twingate = {
      source  = "twingate/twingate"
      version = "~> 0.1.6"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = "us-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "twingate" {
  api_token = var.twingate_api_key
  network   = var.twingate_network_slug
}
