output "vpc_id" {
  description = "VPC ID"
  value = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of ID's of public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of ID's of private subnets"
  value       = module.vpc.private_subnets
}