output "subnet_az" {
    value = aws_subnet.test.availability_zone
  
}

output "vpc_id" {
    value = aws_vpc.dev.id
  
}