output "sg_ec2" {
    description = "Security group for ec2 instances"
    value       = aws_security_group.test_sg_ec2.id
}

output "sg_alb" {
    description = "Security group for load balancer"
    value       = aws_security_group.test_sg_alb.id
}

output "sg_db" {
    description = "Security group for database"
    value       = aws_security_group.test_sg_db.id
}