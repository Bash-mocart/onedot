output "pub_subnet_id_a" {
  value = aws_subnet.pub_subnet_a.id
}

output "pub_subnet_id_b" {
  value = aws_subnet.pub_subnet_b.id
}

output "pri_subnet_id_a" {
  value = aws_subnet.pri_subnet_a.id
}

output "pri_subnet_id_b" {
  value = aws_subnet.pri_subnet_b.id
}


output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "sg_allow_8888" {
  value = aws_security_group.allow_8888.id
}

output "sg_allow_80" {
  value = aws_security_group.allow_80.id
}


