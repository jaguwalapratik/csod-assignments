### Assumption:

We have an AWS MySql RDS already setup (Single-AZ) for cost concern

----

Here we are using AWS RDS Multi-AZ feature to do the require modifications.


Script takes two input parameters

- DBInstanceIdentifier: Name of rds database instance
- InstanceType: Type of database instance with which we want to modify the instance class

## Steps performed in following sequence:

- Check existance of RDS DB Instance
- Enable Multi AZ (We can add check to ignore if instance is already launched with multi az setup)
- Wait for multi az changes to take effect
- Start modifying db instance class using supplied parameter
- Wait for db instance type changes to take effect
- Disable multi az (We can add check to ingore this if instance is already launched with multi az setup)