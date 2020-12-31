# Retrieve default vpc, subnets & security group
$VpcId = (aws ec2 describe-vpcs --filters "Name=isDefault, Values=true" --query "Vpcs[0].VpcId") -replace '"',""
$SubnetsList = aws ec2 describe-subnets --filter "Name=vpc-id,Values=$VpcId" --query 'Subnets[?MapPublicIpOnLaunch==`false`].SubnetId' | ConvertFrom-Json
$SecurityGroupId = (aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VpcId" --group-names default --query "SecurityGroups[0].GroupId") -replace '"',""

if($SubnetsList.Length -gt 1) {
    $SubnetIds = $SubnetsList -Join ","

    $LambdaVpcRole = "lambda-vpc-role"
    $LambdaVpcRoleArn = aws iam get-role --role-name $LambdaVpcRole --query "Role.Arn"

    #Lambda to create dummy tables in AWS RDS MySQL
    Compress-Archive -Path .\app\* -DestinationPath app.zip -Force
    aws lambda create-function --function-name  SetupTableWithDummyRecords --runtime python3.8 --zip-file fileb://app.zip --handler app.handler --role $LambdaVpcRoleArn --vpc-config SubnetIds=$SubnetIds,SecurityGroupIds=$SecurityGroupId
    Remove-Item .\app.zip

    #Lambda to monitor health of the website endpoint
    Compress-Archive -Path .\child\* -DestinationPath child.zip -Force
    aws lambda create-function --function-name WebsiteMonitor --runtime python3.8 --zip-file fileb://child.zip --handler app.handler --role $LambdaVpcRoleArn --vpc-config SubnetIds=$SubnetIds,SecurityGroupIds=$SecurityGroupId --memory-size 256 --timeout 300
    Remove-Item -Path .\child.zip

    #Parent lambda which will fetch list of website endpoints from database
    #and invoke WebsiteMonitor lambda
    Compress-Archive -Path .\parent\* -DestinationPath parent.zip -Force
    $lambda = aws lambda create-function --function-name ScheduledLambdaForMonitoring --runtime python3.8 --zip-file fileb://parent.zip --handler app.handler --role $LambdaVpcRoleArn --vpc-config SubnetIds=$SubnetIds,SecurityGroupIds=$SecurityGroupId --memory-size 256 --timeout 300| ConvertFrom-Json 
    Remove-Item -Path .\parent.zip
    
    $targets = '{\"Id\":\"1\",\"Arn\":\"'+$lambda.FunctionArn+'\"}'
    
    $rule = aws events put-rule --name MonitorWebsites --schedule-expression 'rate(5 minutes)' | ConvertFrom-Json
    
    aws lambda add-permission --function-name ScheduledLambdaForMonitoring --statement-id ScheduledEvent --action 'lambda:InvokeFunction' --principal events.amazonaws.com --source-arn $rule.RuleArn
    
    aws events put-targets --rule MonitorWebsites --targets $targets
    
    Write-Output "Wait until lambda function `"SetupTableWithDummyRecords`" becomes active..."
    aws lambda wait function-active --function-name SetupTableWithDummyRecords
    
    if($LASTEXITCODE -eq 255) {
        Write-Host "Wait for active state exhausted after 60 failed checks"
    } else {
        aws lambda invoke --function-name SetupTableWithDummyRecords output.txt   
    }
}
