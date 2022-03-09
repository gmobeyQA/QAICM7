# MODULE check Configure the ESXi Hosts as NTP Clients
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
# Connect to host H1
Connect-VIServer -Server $CurrentH1 -User $CurrentH1User -Password $CurrentH1Pass  >$null 2>&1
start-sleep 1
# Check NTP Service on H1
$ThisSvc=Get-VmHostService -VMHost $CurrentH1| Where-Object {$_.Running -eq $true} | Where-Object {$_.key -eq "ntpd"} 
if ($ThisSvc.Running -eq $True)
{
$ProgressTextBox.text= "Ntp is running on $CurrentH1"
# a delay so the message can be seen
Start-sleep 5
$isRunningH1=$true
}
else
{
$ProgressTextBox.text= "Ntp is not running on $CurrentH1"
# a delay so the message can be seen
Start-sleep 5
$isRunningH1=$False
}
#Disconnect From Host
Disconnect-VIServer -Server $CurrentH1 -Confirm:$false
        $DefaultVIServer = $null
Start-Sleep 1
#H2
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
# Connect to host H2
Connect-VIServer -Server $CurrentH2 -User $CurrentH2User -Password $CurrentH2Pass  >$null 2>&1
start-sleep 1
# Check NTP Service on H2
$ThisSvc=Get-VmHostService -VMHost $CurrentH2| Where-Object {$_.Running -eq $true} | Where-Object {$_.key -eq "ntpd"} 
if ($ThisSvc.Running -eq $True)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "Ntp is running on $CurrentH2"
 # a delay so the message can be seen
 Start-sleep 5
 $isRunningH2=$true
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "Ntp is not running on $CurrentH2"
 # a delay so the message can be seen
 Start-sleep 5
 $isRunningH2=$False
}
#Disconnect From Host
Disconnect-VIServer -Server $CurrentH2 -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
if ($isRunningH1 -and $isRunningH2)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor = "Green"
 $ProgressTextBox.text=  "NTP is running on both Hosts"
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor = "Red"
 $ProgressTextBox.text=  "Redo Lab 7 Task 4 ... NTP is not running on both Hosts"
}

# End of Module