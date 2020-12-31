## Jenkins Job to deploy a ASG with 2 EC2 which has role of IIS, FTP installed (Good to a ALB on above ASG)

### Pre-requisite

Create an image with iis role, ftp service and dotnet core hosting module provisioned using packer with 
powershell provisioner. To do this have already add packer json and powershell script which can be found
[here](https://github.com/jaguwalapratik/csod-assignments/tree/master/packer)

**Note:** Please configure the access key and secret key at system level or configure ec2 instance role 
if we are using AWS EC2 instance to run our jenkins. Or we can configure them in Jenkins Credentials store
and pass them as environment variable in pipeline script.