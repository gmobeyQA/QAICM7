# Startup Misc Script
#  (Generic) Add The Powershell cmdlets - library 
Add-PSSnapin -Name vmware.VimAutomation.Core -ea SilentlyContinue	# automated administration of the vSphere environment.
Import-Module VMware.VimAutomation.Core								# automated administration of the vSphere environment.
$adapter = Get-WmiObject win32_NetworkAdapterConfiguration | where {$_.IPAddress -like '172.19.1.*'}
$DNS = "172.20.10.10"
$adapter.SetDNSServerSearchOrder($DNS)
cd C:\Materials\Downloads\ca-root\certs\win
certutil -addstore -f Root d819a6fb.0.crt
$yourDesktop="$env:USERPROFILE\Desktop\"
IF (Test-Path "L:\lab.pdf" ){Copy-Item -Path 'L:\lab.pdf' -Destination $yourDesktop}
IF (Test-Path "L:\*handout*.rtf" ){Copy-Item -Path 'L:\*handout*.rtf' -Destination $yourDesktop}
IF (Test-Path "L:\Licences.HTM" ){
Copy-Item -Path 'L:\Licences.HTM' -Destination 'C:\Materials\Licenses\Licences.HTM'
Copy-Item -Path 'C:\Materials\Licenses\VMware Licences.lnk' -Destination $yourDesktop
}
# make sure the services on sa-vcsa-01 are started
$User = "root"
$PWord = ConvertTo-SecureString -String "VMware1!" -AsPlainText -Force
$vcsaCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User, $PWord
New-SSHSession -ComputerName sa-vcsa-01.vclass.local -Credential $vcsaCredential -Force
Invoke-SSHCommandStream "service-control --start --all" -SessionId 0 
#Invoke-SSHCommandStream "service-control --status --all" -SessionId 0 
Remove-SSHSession 0
clear