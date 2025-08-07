output "subnet1_id" {
  value = aws_subnet.subnets["subnet-1"].id
}

output "subnet2_id" {
  value = aws_subnet.subnets["subnet-2"].id
}

output "vpc_id" {
  description = "ID of VPC"
  value       = aws_vpc.main.id
}

output "cidr_block" {
  value = aws_vpc.main.cidr_block
  
}