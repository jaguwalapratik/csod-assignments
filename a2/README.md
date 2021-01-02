### Pre-requisite:

- Default VPC with 2 public subnet and 2 private subnet
- Default security group
- 2 NAT Gateway in both public subnet 
- NAT Gateway entries in Private Route Table
- An AWS MySQL RDS instance up and running in private subnet

### Scripts

[create-role.ps1](https://github.com/jaguwalapratik/csod-assignments/tree/master/a2/create-role.ps1): 
    - Create execution role which gives our lambda function permission to access aws resources
    
[create-update-lambda.ps1](https://github.com/jaguwalapratik/csod-assignments/tree/master/a2/create-update-lambda.ps1):
    - Register 3 lambda function using aws cli
        * SetupTableWithDummyRecords
        * ScheduledLambdaForMonitoring
        * WebsiteMonitor
    - Create event rule to trigger one of the lambda at every 5 minute interval
    
[setup-db.ps1](https://github.com/jaguwalapratik/csod-assignments/tree/master/a2/setup-db.ps1):
    - Create database subnet group
    - Create MySql RDS instance
    
[delete-lambda.ps1](https://github.com/jaguwalapratik/csod-assignments/tree/master/a2/delete-lambda.ps1):
    - Delete lambdas
    - Delete event rule
    
[delete-role.ps1](https://github.com/jaguwalapratik/csod-assignments/tree/master/a2/delete-role.ps1):
    - Delete the respective roles
    
**Note**: Please configure database endpoint and password in **rds_config.py**

### Implementation Details:

**ScheduledLambdaForMonitoring** will fetch the website url for mysql database table. It will invoke 
the **WebsiteMonitor** lambda by passing the respective url which will perform the health check and
return the status of health check to parent lambda function.

We can combine both the lambda into one which will reduce the invocation time. Having standalone lambda
for health monitoring provides other approach.

**WebsiteMonitor** lambda also record metric in CloudWatch. We can create an alarm in AWS CloudWatch 
based on this custom metric and configure AWS SNS Topic to send out notification to subscribers.

### Limitations

**Timeout** Maximum execution time for lambda function is 15 minutes. When the specified timeout is 
reached, AWS Lambda terminates execution of Lambda function

To counter this we can have one dumb ec2 instance with some kind of scripts that will execute in loop
and fetch record from database and invoke "WebsiteMonitor" lambda using cli.
