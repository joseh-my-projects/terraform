locals {
  project_name = "Dev"
}

resource "aws_instance" "my_server" {
    count = 3
    ami = data.aws_ami.amazon_linux_3.id
    instance_type = var.instance_type

    tags = {
      Name = "${local.project_name}-MyServer"
      Terraform = "True"

    }
  
}

data "aws_ami" "amazon_linux_3" {
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