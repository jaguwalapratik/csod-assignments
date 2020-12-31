output "alb_dns_name" {
    description = "The public domain of the load-balancer"
    value       = aws_lb.test_alb.dns_name
}

output "target_group_arn" {
    description = "Target group arn"
    value       = aws_lb_target_group.test_lb_target_group.arn
}