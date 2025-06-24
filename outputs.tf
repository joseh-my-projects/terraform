output "private_ip_east" {
    value = aws_instance.my_server_east[*].private_ip
  
}

output "private_ip_west" {
    value = aws_instance.my_server_west[*].private_ip
  
}

output "amazon_linux_3_ami_id_east" {
  value = data.aws_ami.amazon_linux_3_east.id
}

output "amazon_linux_3_ami_id_west" {
  value = data.aws_ami.amazon_linux_3_west.id
}