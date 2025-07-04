resource "aws_instance" "my_server_east" {
    count = length(var.instance_names)
    ami = data.aws_ami.amazon_linux_3_east.id
    instance_type = var.instance_type

    tags = {
      Name = var.instance_names[count.index]
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
