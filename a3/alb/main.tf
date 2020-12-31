resource "aws_lb" "test_alb" {
    name                       = "test-alb"
    internal                   = false
    load_balancer_type         = "application"
    security_groups            = [var.sg_alb]
    subnets                    = [var.public_subnet1, var.public_subnet2]
    enable_deletion_protection = false

    tags = {
        Name = "test-alb"
    }
}

resource "aws_lb_target_group" "test_lb_target_group" {
    name_prefix = "test"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = var.vpc_id

    health_check {
        interval            = 30
        healthy_threshold   = 3
        unhealthy_threshold = 5
        timeout             = 5
        path                = "/"
        port                = 80
        matcher             = 200
    }

    tags = {
        Name = "test-lb-target-group"
    }
}

resource "aws_lb_listener" "test_lb_listener" {
    load_balancer_arn = aws_lb.test_alb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.test_lb_target_group.arn
    }
}