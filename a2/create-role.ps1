# Create VPC Execution Role
$LambdaVpcRole = "lambda-vpc-role"
$response = aws iam create-policy --policy-name "lambda-vpc-execution" --policy-document file://./policies/lambda_vpc_execution.json | ConvertFrom-Json
aws iam create-role --role-name $LambdaVpcRole --assume-role-policy file://./policies/lambda_trust_policy.json
aws iam attach-role-policy --role-name $LambdaVpcRole --policy-arn $response.Policy.Arn