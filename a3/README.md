## Jenkins Job to deploy a ASG with 2 EC2 which has role of IIS, FTP installed (Good to a ALB on above ASG)

### Pre-requisite

Create an image with iis role, ftp service and dotnet core hosting module provisioned using packer with 
powershell provisioner. To do this we have used packer and powershell script to setup and install required 
dependencies. It can be found [here](https://github.com/jaguwalapratik/csod-assignments/tree/master/packer)

**Note:** Please configure the access key and secret key at system level or configure ec2 instance role 
if using AWS EC2 instance to run jenkins. Or we can configure them in Jenkins Credentials store
and pass them as environment variable in pipeline script.
