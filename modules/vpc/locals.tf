locals {
  region = "us-east-1"

  subnets = {
    subnet1 = {
      cidr_block = "10.0.1.0/24"
      availability_zone = "us-east-1a"
      map_public_ip_on_launch = true
        tags = {
          Name = "Subnet1"
        }
    }
    subnet2 = {
      cidr_block = "10.0.2.0/24"
      availability_zone = "us-east-1b"
      map_public_ip_on_launch = true
        tags = {
          Name = "Subnet2"
        }
    }

  }

  ingress_rules = {
    http = {
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = 80
      ip_protocol = "tcp"
      to_port     = 80
    }
    https = {
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = 443
      ip_protocol = "tcp"
      to_port     = 443

    }

  }
  
}