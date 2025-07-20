output "repository_url" {
  description = "repo url"
  value       = data.aws_ecr_repository.ecr_repo.repository_url
}

output "security_group_id" {
  description = "ID of SG"
  value       = aws_security_group.ecs_sg.id
}