$temp_path = "C:\temp\"

if( ![System.IO.Directory]::Exists( $temp_path ) ) {
    New-Item -ItemType directory -Path $temp_path
}

$whb_installer_url = "https://download.visualstudio.microsoft.com/download/pr/7e35ac45-bb15-450a-946c-fe6ea287f854/a37cfb0987e21097c7969dda482cebd3/dotnet-hosting-3.1.10-win.exe"
$whb_installer_file = $temp_path + [System.IO.Path]::GetFileName( $whb_installer_url )

Try {
    Invoke-WebRequest -Uri $whb_installer_url -OutFile $whb_installer_file

    Write-Output ""
    Write-Output "Windows Hosting Bundle Installer downloaded"
    Write-Output "- Execute the $whb_installer_file to install the ASP.Net Core Runtime"
    Write-Output ""

} Catch {
    Write-Output ( $_.Exception.ToString() )
    Break
}

$args = New-Object -TypeName System.Collections.Generic.List[System.String]
$args.Add("/quiet")
$args.Add("/install")
$args.Add("/norestart")
$Output = Start-Process -FilePath $whb_installer_file -ArgumentList $args -NoNewWindow -Wait -PassThru
If($Output.Exitcode -Eq 0) {
    Write-Host "Restarting iis service"
    net stop was /y
    net start w3svc
}
else {
    Write-HError "`t`t Something went wrong with the installation. Errorlevel: ${Output.ExitCode}"
    Exit 1
}