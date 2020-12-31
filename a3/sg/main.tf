resource "aws_security_group" "test_sg_ec2" {
    name   = "test_ec2_sg"
    vpc_id = var.vpc_id

    ingress {
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 3389
        to_port     = 3389
    }

    ingress {
        protocol        = "tcp"
        from_port       = 80
        to_port         = 80
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        protocol        = "tcp"
        from_port       = 443
        to_port         = 443
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        protocol        = "tcp"
        from_port       = 5986
        to_port         = 5986
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        protocol        = "tcp"
        from_port       = 21
        to_port         = 21
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        protocol        = "tcp"
        from_port       = 6000
        to_port         = 6100
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 0
        to_port     = 0
    }

    tags = {
        Name = "test-sg-ec2"
    }
}

resource "aws_security_group" "test_sg_db" {
    name   = "test_db_sg"
    vpc_id = var.vpc_id

    ingress {
        protocol    = "tcp"
        security_groups = [aws_security_group.test_sg_ec2.id]
        from_port   = 3306
        to_port     = 3306
    }

    egress {
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 0
        to_port     = 0
    }

    tags = {
        Name = "test-sg-db"
    }
}

# Security Group for ALB
resource "aws_security_group" "test_sg_alb" {
    name   = "test_sg_alb"
    vpc_id = var.vpc_id

    ingress {
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 80
        to_port     = 80
    }

    ingress {
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 443
        to_port     = 443
    }

    egress {
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 0
        to_port     = 0
    }

    tags = {
        Name = "test-sg-alb"
    }
}