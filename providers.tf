provider "aws" {
  region     = local.region
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "vercel" {
  api_token = var.vercel_api_token
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    vercel = {
      source  = "vercel/vercel"
      version = "~> 0.4"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    bucket  = "yamato-k-terraform-state"
    region  = "ap-northeast-1"
    key     = "terraform.tfstate"
    encrypt = true
  }
}