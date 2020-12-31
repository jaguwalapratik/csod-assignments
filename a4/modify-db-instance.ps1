param(
    [string] $DBInstanceIdentifier,
    [string] $InstanceType
)


if($DBInstanceIdentifier -eq "") {
    Write-Host "Param db_instance_identifier is required"
    return
}

if($InstanceType -eq "") {
    Write-Host "Param instance_type is required"
    return
}

Function IsInstanceExists() {
    $result = aws rds describe-db-instances --db-instance-identifier $DBInstanceIdentifier 2>$null
    
    Write-Host "AWS CLI returned with exit status code of $LastExitCode"
    
    Write-Host "Visit https://docs.aws.amazon.com/cli/latest/userguide/cli-usage-returncodes.html for more info."
    
    return $result
}

Function Wait() {
    do {
        $result = aws rds describe-db-instances --db-instance-identifier test-db --query "DBInstances[0].DBInstanceStatus"
        Write-Host "Current state $result"
        
        if(($result -replace '"', "") -eq "available") {
            break;
        }
        
        sleep(15)
    } while($true)
}

Function Enable-MultiAz() {
    # Enable multi az
    Write-Host "Enabling multi az"
    $result = aws rds modify-db-instance --db-instance-identifier test-db --multi-az --apply-immediately
}

Function Disable-MultiAz() {
    # Disable multi az
    Write-Host "Disabling multi az"
    $result = aws rds modify-db-instance --db-instance-identifier test-db --no-multi-az --apply-immediately
}

Function Modify-DB-InstanceType() {
    Write-Host "Modifying db instance type"
    $result = aws rds modify-db-instance --db-instance-identifier test-db --db-instance-class "db.t3.small" --apply-immediately
}

$result = IsInstanceExists

if($result -eq $null) {
    
    Write-Host "DB instance `"${DBInstanceIdentifier}`" not found."
    
    exit 0
}

#$result = $result | ConvertFrom-Json

$start_time = Get-Date
Write-Host "Start time $start_time"

Enable-MultiAz

sleep(60)

Wait

Modify-DB-InstanceType

sleep(60)

Wait

Disable-MultiAz

$end_time = Get-Date
Write-Host "End time $start_time"

$total_execution_time = ($end_time - $start_time).Seconds

Write-Host "Total execution time in seconds $total_execution_time"

