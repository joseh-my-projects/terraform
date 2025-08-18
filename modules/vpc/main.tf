module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  name            = var.vpc_name
  cidr            = var.cidr_block
  azs             = var.availability_zones
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    Name = "Public-subnets"
  }
  private_subnet_tags = {
    Name = "Private-subnets"
  }

  tags = {
    Environment = var.environment
  }

  vpc_tags = {
    Name = "Main-VPC"
  }

}