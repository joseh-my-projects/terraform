terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.0.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "main"
  }
}

locals {
  ingress = [{
    port = 443
    description = "Port 443"
  },
  {
    port = 80
    description = "Port 80"
  }]
}

resource "aws_security_group" "example" {
    vpc_id = aws_vpc.main.id

    dynamic "ingress" {
        for_each = local.ingress
        content {
            from_port        = ingress.value.port
            to_port          = ingress.value.port
            protocol         = "tcp"
            cidr_blocks      = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []

        }
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }


}


