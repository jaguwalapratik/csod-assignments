<powershell>
Start-Transcript -Path "C:\transcripts\transcript0.txt" -NoClobber -Append

# Enable WinRM for Ansible
$admin = [adsi]("WinNT://./administrator, user")
$parameter = Get-SSMParameter -Name test_password
$admin.PSBase.Invoke("SetPassword", $parameter.Value)
winrm delete winrm/config/Listener?Address=*+Transport=HTTP
winrm delete winrm/config/Listener?Address=*+Transport=HTTPS
Invoke-Expression ((New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'))

</powershell>