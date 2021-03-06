# MODULE TO Increase the Size of a VMDK File
$ProgressTextBox.BackColor="Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Increase the Size of a VMDK File)"
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
$ProgressTextBox.text=""
$ProgressTextBox.text="Increase VM $CurrVM3 HD from 25GB to 27GB"
start-sleep 5
Get-VM -Name $CurrVM3 >$null 2>&1
if ($?)
{
 $Thisvm = Get-VM -Name $CurrVM3
 if ($Thisvm.PowerState -ne "PoweredOn")
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Booting VM $CurrVM3"
  $Thisvm | Start-VM -Confirm:$false  >$null 2>&1
  # a delay so the message can be seen
  Start-Sleep 5
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "VM $CurrVM3 is already Booted"
  start-sleep 5
 }
 $thisDisk=Get-HardDisk -VM $CurrVM3
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "VM $CurrVM3 HD Current Size is "+$thisDisk.CapacityGB+"GB"
 start-sleep 5
 if ($thisDisk.CapacityGB -eq "27")
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "VM $CurrVM3 HD is already set to 27GB"
  start-sleep 5
 }
 else
 {
  $ProgressTextBox.text="Set VM $CurrVM3 HD to 27GB"
  Get-HardDisk -VM  $CurrVM3 | Set-HardDisk -CapacityGB 27 -Confirm:$false
  # a delay so the message can be seen
  start-sleep 5
 }
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Green"
 $ProgressTextBox.text= "Lab 18 Task 2 Done"
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Red3"
 $ProgressTextBox.text= "$CurrVM is Missing"
}

# Disconnect From vc
Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null

# End of Module