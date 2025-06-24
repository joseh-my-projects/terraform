locals {
  project_name = "Dev"
}

resource "aws_instance" "my_server_east" {
    count = 2
    ami = data.aws_ami.amazon_linux_3_east.id
    instance_type = var.instance_type

    tags = {
      Name = "${local.project_name}-MyServer"
      Terraform = "True"

    }
  
}


resource "aws_instance" "my_server_west" {
    count = 2
    ami = data.aws_ami.amazon_linux_3_west.id
    instance_type = var.instance_type
    provider = aws.west

    tags = {
      Name = "${local.project_name}-MyServer"
      Terraform = "True"

    }
  
}

data "aws_ami" "amazon_linux_3_east" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-*"] # Adjust the regex as needed for the exact name pattern
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "amazon_linux_3_west" {
  provider = aws.west
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-*"] # Adjust the regex as needed for the exact name pattern
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}