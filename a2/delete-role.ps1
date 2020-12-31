# Delete VPC Execution Role
$LambdaVpcRole = "lambda-vpc-role"
$ListOfAttachedPolicies = aws iam list-attached-role-policies --role-name $LambdaVpcRole | ConvertFrom-Json
Foreach($attachedPolicy in $ListOfAttachedPolicies.AttachedPolicies) {
    aws iam detach-role-policy --role-name $LambdaVpcRole --policy-arn $attachedPolicy.PolicyArn 2>$null
    aws iam delete-policy --policy-arn $attachedPolicy.PolicyArn 2>$null
}
aws iam delete-role --role-name $LambdaVpcRole