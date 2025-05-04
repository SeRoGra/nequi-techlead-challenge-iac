terraform {
  required_version = ">= 1.6.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
  backend "s3" {
    bucket         = "s3-nequi-techlead-challenge-terraform"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "dynamo-nequi-techlead-challenge-terraform-lock"
  }
}

provider "aws" {
  region  = "us-east-1"
  alias   = "main"
}