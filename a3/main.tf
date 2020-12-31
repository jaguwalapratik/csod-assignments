terraform {
    backend "s3" {
        bucket = "csod-assignments"
        key    = "infrastructure.tfstate"
        region = "us-west-2"
    }
}

locals {
    aws_region = "us-west-2"
}

provider "aws" {
    region = local.aws_region
}

module "vpc" {
    source = "./vpc"
}

module "sg" {
    source = "./sg"
    
    vpc_id                  = module.vpc.vpc_id
}

module "alb" {
    source = "./alb"

    vpc_id                  = module.vpc.vpc_id
    public_subnet1          = module.vpc.public_subnet1
    public_subnet2          = module.vpc.public_subnet2
    sg_alb                  = module.sg.sg_alb
}

module "asg" {
    source = "./asg"
    
    public_subnet1          = module.vpc.public_subnet1
    public_subnet2          = module.vpc.public_subnet2
    sg_ec2                  = module.sg.sg_ec2
    alb_target_group_arn    = module.alb.target_group_arn
    ami_id                  = var.ami_id
}

module "rds" {
    source = "./rds"
    
    private_subnet1          = module.vpc.private_subnet1
    private_subnet2          = module.vpc.private_subnet2
    sg_db                    = module.sg.sg_db
}

module "route53" {
    source = "./route53"
    
    vpc_id                   = module.vpc.vpc_id
    db_endpoint              = module.rds.db_address
}
