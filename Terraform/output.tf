output "subnet_id" {
  value = aws_subnet.subnet1.id
}

output "subnet2_id" {
  value = aws_subnet.subnet2.id
}

output "security_group_id" {
  value = aws_security_group.sg.id
}

output "public_ip" {
  value = aws_eip.elastic.public_ip
}