locals {
    asg_min_size        = 2
    asg_max_size        = 2
    asg_desired_size    = 2 
    launch_config_name  = "test-launch-config"
    instance_type       = "t2.micro"
    key_pair            = "test_kp"
}

data "aws_ami" "windows" {
    most_recent = true
    owners              = ["self"]
    name_regex          = "Win2016IISRoleWithFTP"
    
    filter {
        name = "name"
        values = ["Win2016IISRoleWithFTP"]
    }
}

resource "aws_launch_configuration" "test_lc" {
    name_prefix                 = local.launch_config_name
    image_id                    = data.aws_ami.windows.id
    instance_type               = local.instance_type
    iam_instance_profile        = aws_iam_instance_profile.test_profile.id
    key_name                    = local.key_pair
    user_data                   = file("./asg/setup.ps1")
    associate_public_ip_address = true
    security_groups             = [var.sg_ec2]
}

resource "aws_autoscaling_group" "test_asg" {
    name                      = aws_launch_configuration.test_lc.name
    min_size                  = local.asg_min_size
    desired_capacity          = local.asg_desired_size
    max_size                  = local.asg_max_size
    launch_configuration      = aws_launch_configuration.test_lc.name
    vpc_zone_identifier       = [var.public_subnet1, var.public_subnet2]
    target_group_arns         = [var.alb_target_group_arn]
    health_check_grace_period = 480
    health_check_type         = "ELB"

    lifecycle {
        create_before_destroy = true
    }

    tags = concat([{
        "key"                 = "Name"
        "value"               = "test-asg"
        "propagate_at_launch" = true
    }]) 
}

resource "aws_iam_instance_profile" "test_profile" {
    name = "test_profile"
    role = aws_iam_role.test_role.name
}

resource "aws_iam_role" "test_role" {
    name = "test_role"
    path = "/"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy" "test_ssm_policy" {
    name        = "test-ssm-policy"
    description = "An ssm access policy"
    policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action" : [
                "ssm:GetParameter"
            ],
            "Effect" : "Allow",
            "Resource" : "*",
            "Sid": ""
        }   
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "test_ssm_policy_attach" {
    name       = "test-ssm-policy-attachment"
    roles      = [aws_iam_role.test_role.name]
    policy_arn = aws_iam_policy.test_ssm_policy.arn
}
