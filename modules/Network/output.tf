output "sg_id" {
  value = aws_security_group.sg.id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet[0].id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet[0].id
}
