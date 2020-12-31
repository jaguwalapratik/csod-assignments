resource "aws_db_subnet_group" "test_db_subnet_group" {
    name        = "test_db_subnet_group"
    subnet_ids  = [var.private_subnet1, var.private_subnet2]
    description = "Database subnet group"
}

resource "random_password" "test_db_password" {
    length  = 20
    special = false
}

resource "aws_ssm_parameter" "test_db_password" {
    name   = "/db/${var.instance_name}/password"
    value  = random_password.test_db_password.result
    type   = "String"
}

resource "aws_db_instance" "test_db" {
    engine                                  = var.engine
    engine_version                          = var.engine_version
    identifier                              = var.instance_name
    username                                = var.db_username
    password                                = aws_ssm_parameter.test_db_password.value
    instance_class                          = var.instance_type
    ca_cert_identifier                      = var.ca_cert

    storage_type                            = "gp2"
    allocated_storage                       = 20
    iops                                    = null
    max_allocated_storage                   = 0
    storage_encrypted                       = false

    multi_az                                = var.multi_az
    db_subnet_group_name                    = aws_db_subnet_group.test_db_subnet_group.id
    publicly_accessible                     = false
    vpc_security_group_ids                  = [ var.sg_db ]
    port                                    = var.db_port

    name                                    = "csoddb"
    parameter_group_name                    = var.parameter_group_name
    option_group_name                       = var.option_group_name

    backup_retention_period                 = 3
    backup_window                           = null
    copy_tags_to_snapshot                   = true

    monitoring_interval                     = 0
    monitoring_role_arn                     = null

    enabled_cloudwatch_logs_exports         = []

    performance_insights_enabled            = false

    auto_minor_version_upgrade              = true
    maintenance_window                      = null
    deletion_protection                     = false
    
    skip_final_snapshot                     = true
}