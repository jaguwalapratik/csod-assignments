output "db_endpoint" {
    description = "Endpoint to access database"
    value = aws_db_instance.test_db.endpoint
}
output "db_address" {
    description = "Address to access database"
    value = aws_db_instance.test_db.address
}

output "db_username" {
    description = "Database username"
    value = aws_db_instance.test_db.username
}

output "test_db_password" {
    description = "Name of SSM parameter"
    value       = aws_ssm_parameter.test_db_password.name
}

output "db_name" {
    description = "Database name"
    value = aws_db_instance.test_db.name
}

output "db_id" {
    description = "Database identifier"
    value = aws_db_instance.test_db.id
}