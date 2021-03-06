# MODULE TO Rename a Virtual Machine in the vCenter Server Inventory
$ProgressTextBox.BackColor="Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Rename a Virtual Machine in the vCenter Server Inventory)"
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
$CurrentVC="sa-vcsa-01.vclass.local"
$CurrentVCUser="administrator@vsphere.local"
$CurrentVCPass="VMware1!"
$CurrVM3="Win10-06"

# Connect to vc
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
$vCenter=Connect-VIServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass # >$null 2>&1
Get-VM -Name $CurrVM3 >$null 2>&1
if ($?)
{
 $Thisvm = Get-VM -Name $CurrVM3
 if ($Thisvm.PowerState -eq "PoweredOn")
 {
 # if we can try to shut it down otherwise power it off
 if($Thisvm.Guest.State -eq "Running")
 {
  $ProgressTextBox.text=  "Shutdown Virtual Machine $CurrVM3"
  # a delay so the message can be seen
  Start-sleep 1
  Shutdown-VMGuest -VM $Thisvm -Confirm:$false >$null 2>&1
 }
 else
 {
  $ProgressTextBox.text=  "Power Off Virtual Machine $CurrVM3"
  # a delay so the message can be seen
  Start-sleep 1
  Stop-VM -VM $Thisvm -Confirm:$false >$null 2>&1
 }
}
else
{
$ProgressTextBox.text=  "Virtual Machine $CurrVM3 is already Shutdown"
# a delay so the message can be seen
Start-sleep 1
}
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Green"
 $ProgressTextBox.text= "Lab 18 Task 3 Done"
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Red"
 $ProgressTextBox.text= "$CurrVM3 is Missing or has The wrong name"
}

# Disconnect From vc
Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null

# End of Module