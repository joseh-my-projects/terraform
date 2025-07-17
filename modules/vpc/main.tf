resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    region = local.region

    enable_dns_hostnames = true
    
    tags = {
      Name = "main-vpc"
    } 
}

resource "aws_subnet" "subnet" {
  for_each = local.subnets
  
  vpc_id = aws_vpc.main.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  tags = {
    Name = each.key
  }

}

resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.main.id
  name = "Allow http"
  description = "Allowing traffic on port 80"

  tags = {
    Name = "ecs_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rules" {
  security_group_id = aws_security_group.ecs_sg.id
  for_each = local.ingress_rules

  cidr_ipv4   = each.value.cidr_ipv4
  from_port   = each.value.from_port
  ip_protocol = each.value.ip_protocol
  to_port     = each.value.to_port

}

resource "aws_internet_gateway" "internet_gateway" {
 vpc_id = aws_vpc.main.id
 tags = {
   Name = "internet_gateway"
 }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  
}

resource "aws_route_table_association" "subnet1_route" {
  subnet_id = aws_subnet.subnet["subnet1"].id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet2_route" {
  subnet_id = aws_subnet.subnet["subnet2"].id
  route_table_id = aws_route_table.route_table.id
}

