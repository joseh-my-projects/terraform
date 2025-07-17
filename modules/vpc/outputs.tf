output "subnet1_id_public" {
  description = "The ID of the specific subnet"
  value       = aws_subnet.subnet["subnet1"].id
}

output "subnet2_id_public" {
  description = "The ID of the specific subnet"
  value       = aws_subnet.subnet["subnet2"].id
}

output "security_group_id" {
  description = "ID of SG"
  value = aws_security_group.ecs_sg.id
}

output "vpc_id" {
  description = "ID of VPC"
  value = aws_vpc.main.id
}