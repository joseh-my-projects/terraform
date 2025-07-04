# Terraform Block
terraform {
  cloud { 
    organization = "keeper84_org" 

    workspaces { 
      name = "terraform-workspace" 
    } 
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider Block
provider "aws" {
  region = "us-east-1"

}

# Provider Block
provider "aws" {
  region = "us-west-1"
  alias = "west"

}
