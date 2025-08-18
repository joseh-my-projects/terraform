locals {
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
    tcp = {
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = 8080
      ip_protocol = "tcp"
      to_port     = 8080
    }
  }
}