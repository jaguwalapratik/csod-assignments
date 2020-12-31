Start-Transcript -Path "C:\transcripts\transcript0.txt" -NoClobber
Install-WindowsFeature -name Web-FTP-Server -IncludeAllSubFeature
Install-WindowsFeature -name Web-Server -IncludeManagementTools
Import-Module WebAdministration
$FTPSiteName = 'FTPSites'
$FTPRootDir = 'C:\websites'
$FTPPort = 21

if (!(Test-Path $FTPRootDir)) {
    New-Item -Path $FTPRootDir -ItemType Directory
}

New-WebFtpSite -Name $FTPSiteName -Port $FTPPort -PhysicalPath $FTPRootDir

Set-ItemProperty "IIS:\Sites\$FTPSiteName" -Name ftpServer.security.ssl.controlChannelPolicy -Value 0
Set-ItemProperty "IIS:\Sites\$FTPSiteName" -Name ftpServer.security.ssl.dataChannelPolicy -Value 0
Set-ItemProperty "IIS:\Sites\$FTPSiteName" -Name ftpServer.security.authentication.basicAuthentication.enabled -Value $true
Add-WebConfiguration "/system.ftpServer/security/authorization" -value @{accessType="Allow";roles="";permissions="Read,Write";users="*"} -PSPath IIS:\ -location "$FTPSiteName"
Set-WebConfiguration "/system.ftpServer/firewallSupport" -PSPath "IIS:\" -Value @{lowDataChannelPort="6000";highDataChannelPort="6100";}
Restart-WebItem "IIS:\Sites\$FTPSiteName"
net stop ftpsvc
net start ftpsvc