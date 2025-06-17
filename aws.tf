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
