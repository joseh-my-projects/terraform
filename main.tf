terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  profile = "default"
}

variable "instance_type" {
    type = string
  
}

locals {
  project_name = "Dev"
}

resource "aws_instance" "my_server" {
    ami = "ami-09e6f87a47903347c"
    instance_type = var.instance_type

    tags = {
      Name = "${local.project_name}-MyServer"
      Terraform = "True"

    }

  
}

output "private_ip" {
    value = aws_instance.my_server.private_ip
  
}