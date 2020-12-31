output "vpc_id" {
    description = "VPC Identifier"
    value       = aws_vpc.test_vpc.id
}

output "public_subnet1" {
    description = "Public subnet 1"
    value       = aws_subnet.test_public_subnet[0].id
}

output "public_subnet2" {
    description = "Public subnet 2"
    value       = aws_subnet.test_public_subnet[1].id
}

output "private_subnet1" {
    description = "Private subnet 1"
    value       = aws_subnet.test_private_subnet[0].id
}

output "private_subnet2" {
    description = "Private subnet 2"
    value       = aws_subnet.test_private_subnet[1].id
}