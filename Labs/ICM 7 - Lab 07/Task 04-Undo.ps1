# MODULE undo Configure the ESXi Hosts as NTP Clients
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Configure the ESXi Hosts as NTP Clients)"
# a delay so the message can be seen
Start-sleep 1
#  (Generic) Add The Powershell cmdlets - library 
Add-PSSnapin -Name VMware.VimAutomation.Core -ea SilentlyContinue 				# automated administration of the vSphere environment.
#Add-PSSnapin -Name VMware.VimAutomation.License -ea SilentlyContinue 			# Provides the Get-LicenseDataManager cmdlet for managing VMware License components
#Add-PSSnapin -Name VMware.ImageBuilder -ea SilentlyContinue					# managing depots, image profiles, and VIBs.
#Add-PSSnapin -Name VMware.VimAutomation.DeployAutomation -ea SilentlyContinue	# provide an interface to VMware Auto Deploy for provisioning physical hosts with ESXi software
Import-Module VMware.VimAutomation.Core				# automated administration of the vSphere environment.
#Import-Module VMware.VimAutomation.Vds				# managing virtual distributed switches and port groups
#Import-Module VMware.VimAutomation.Cis.Core		# managing vCloud Suite SDK servers
#Import-Module VMware.VimAutomation.Storage			# managing vSphere policy-based storage
#Import-Module VMware.VimAutomation.HA				# Provides the Get-DRMInfo cmdlet for retrieving Distributed Resource Management dump information
#Import-Module VMware.VimAutomation.Cloud
#Import-Module VMware.VimAutomation.PCloud
Clear-Host
# Using Variables to make changes easier
$CurrentH1="sa-esxi-01.vclass.local"
$CurrentH1User="root"
$CurrentH1Pass="VMware1!"
$CurrentH2="sa-esxi-02.vclass.local"
$CurrentH2User="root"
$CurrentH2Pass="VMware1!"
$CurrentNTP="172.20.10.10"
#H1
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
# Connect to host
Connect-VIServer -Server $CurrentH1 -User $CurrentH1User -Password $CurrentH1Pass  >$null 2>&1
start-sleep 1
$ProgressTextBox.text=""
$ProgressTextBox.text=  "Stop Ntp Service on $CurrentH1"
# a delay so the message can be seen
Start-sleep 5 
# Stop NTP Service
Get-VmHostService -VMHost $CurrentH1 | Where-Object {$_.key -eq "ntpd"} | Stop-VMHostService -Confirm:$false
$ProgressTextBox.text=""
$ProgressTextBox.text=  "Set Ntp to not start on $CurrentH1 boot"
# a delay so the message can be seen
Start-sleep 5 
# Set NTP not start on Boot
Get-VmHostService -VMHost $CurrentH1 | Where-Object {$_.key -eq "ntpd"} |Set-VMHostService -Policy Off
Start-sleep 1
$ProgressTextBox.text=""
$ProgressTextBox.text=  "Remove Ntp Server from $CurrentNTP on $CurrentH1"
# a delay so the message can be seen
Start-sleep 5 
# UnSet Ntp Source - bug in command
Remove-VMHostNtpServer -VMHost $CurrentH1 -NtpServer $CurrentNTP -Confirm:$false >$null 2>&1
Start-sleep 5
Start-Sleep 1
#Disconnect From Host
Disconnect-VIServer -Server $CurrentH1 -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
Start-sleep 5
#H2
# Connect to host
Connect-VIServer -Server $CurrentH2 -User $CurrentH2User -Password $CurrentH2Pass  >$null 2>&1
start-sleep 1
$ProgressTextBox.text=""
$ProgressTextBox.text=  "Stop Ntp Service on $CurrentH2"
# a delay so the message can be seen
Start-sleep 5 
# Stop NTP Service
Get-VmHostService -VMHost $CurrentH2 | Where-Object {$_.key -eq "ntpd"} | Stop-VMHostService -Confirm:$false
$ProgressTextBox.text=""
$ProgressTextBox.text=  "Set Ntp to not start on $CurrentH2 boot"
# a delay so the message can be seen
Start-sleep 5 
# Set NTP not start on Boot
Get-VmHostService -VMHost $CurrentH2 | Where-Object {$_.key -eq "ntpd"} |Set-VMHostService -Policy Off
Start-sleep 1
$ProgressTextBox.text=""
$ProgressTextBox.text=  "Remove Ntp Server from $CurrentNTP on $CurrentH2"
# a delay so the message can be seen
Start-sleep 5 
# UnSet Ntp Source - bug in command
Remove-VMHostNtpServer -VMHost $CurrentH2 -NtpServer $CurrentNTP -Confirm:$false >$null 2>&1
Start-Sleep 1
#Disconnect From Host
Disconnect-VIServer -Server $CurrentH2 -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
Start-sleep 1
$ProgressTextBox.text=""
$ProgressTextBox.text=  "NTP unconfigured on both Hosts"
Start-sleep 5
$ProgressTextBox.text=""
$ProgressTextBox.BackColor="Green"
$ProgressTextBox.text= "Lab 7 Task 4 Done"
# End of Module
# End of Module