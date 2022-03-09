# Startup Misc Script
#  (Generic) Add The Powershell cmdlets - library 
Add-PSSnapin -Name vmware.VimAutomation.Core -ea SilentlyContinue	# automated administration of the vSphere environment.
Import-Module VMware.VimAutomation.Core								# automated administration of the vSphere environment.
$adapter = Get-WmiObject win32_NetworkAdapterConfiguration | where {$_.IPAddress -like '172.19.1.*'}
$DNS = "172.20.10.10"
$adapter.SetDNSServerSearchOrder($DNS)
#get DC-RRASS's dhcp supplied adapter's settings
$adapter = Get-WmiObject -Computer 172.20.10.10 win32_NetworkAdapterConfiguration | where {$_.IPAddress -like '172.19.1.*'}
$DNS = "172.20.10.10"
#override the dhcp'd adapter's DNS settings
$adapter.SetDNSServerSearchOrder($DNS)
#put vc's ca cert into root store
cd C:\Materials\Downloads\ca-root\certs\win
certutil -addstore -f Root d819a6fb.0.crt
$yourDesktop="$env:USERPROFILE\Desktop\"
# make sure the services on sa-vcsa-01 are started
$User = "root"
$PWord = ConvertTo-SecureString -String "VMware1!" -AsPlainText -Force
$vcsaCredential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User, $PWord
New-SSHSession -ComputerName sa-vcsa-01.vclass.local -Credential $vcsaCredential -Force
Invoke-SSHCommandStream "service-control --start --all" -SessionId 0 
#Invoke-SSHCommandStream "service-control --status --all" -SessionId 0 
Remove-SSHSession 0
clear