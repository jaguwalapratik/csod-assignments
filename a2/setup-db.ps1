$Database = "testup"
$DBUserName = "admin"
$DBPassword = "this.admin"
$DbSubnetGroup = "test-db-subnet-group"

$VpcId = (aws ec2 describe-vpcs --filters "Name=isDefault, Values=true" --query "Vpcs[0].VpcId") -replace '"',""
$SubnetsList = aws ec2 describe-subnets --filter "Name=vpc-id,Values=$VpcId" --query 'Subnets[?MapPublicIpOnLaunch==`false`].SubnetId' | ConvertFrom-Json

# Create DBSubnet Group
aws rds create-db-subnet-group --db-subnet-group-name $DBSubnetGroup --db-subnet-group-description "Test database subnet group" --subnet-ids $SubnetsList

# Create RDS Database
aws rds create-db-instance --db-name HealthCheckDB --engine MySQL --db-instance-identifier MySQLForLambdaTest --backup-retention-period 3  --db-instance-class db.t2.micro --allocated-storage 5 --no-publicly-accessible --master-username admin --master-user-password this.admin --db-subnet-group-name $DbSubnetGroup 2>$null