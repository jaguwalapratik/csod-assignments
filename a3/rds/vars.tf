variable "private_subnet1" {}
variable "private_subnet2" {}
variable "sg_db" {}
variable "engine" { default = "mysql" }
variable "engine_version" { default = "5.7" }
variable "db_username" { default = "admin" }
variable "instance_name" { default = "test-db" }
variable "multi_az" { default = false}
variable "db_port" { default = 3306 }
variable "instance_type" { default = "db.t3.micro" }
variable "ca_cert" { default = "rds-ca-2019" }
variable "parameter_group_name" { default = "default.mysql5.7" }
variable "option_group_name" { default = "default:mysql-5-7" }