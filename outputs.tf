output "private_ip" {
    value = aws_instance.my_server[*].private_ip
  
}

output "amazon_linux_3_ami_id" {
  value = data.aws_ami.amazon_linux_3.id
}