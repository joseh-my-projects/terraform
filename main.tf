# Terraform Block
terraform {

#  cloud { 
#    organization = "keeper84_org" 

#    workspaces { 
#      name = "terraform-workspace" 
#    } 
#  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Provider Block
provider "aws" {
  region = "us-east-1"
  profile = "default"
}