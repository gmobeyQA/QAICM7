# MODULE Undo Create a Virtual Machine Template
$ProgressTextBox.BackColor="Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Create a Virtual Machine Template)"
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
$CurrentDataCenter="ICM-Datacenter"
$CurrentVTFolder1="Lab VMs"
$CurrentVTFolder2="Lab Templates"
$CurrentH1="sa-esxi-01.vclass.local"
$VM2bTemplate = "Photon-Template"

# Connect to vc
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
$vCenter=Connect-VIServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass # >$null 2>&1
# is it a template ?
Get-Template -Name $VM2bTemplate >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Comvert Template $VM2bTemplate into a VM"
 Get-Template -Name $VM2bTemplate| Set-Template -ToVM
 start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="$VM2bTemplate is already a VM"
 start-sleep 5 
}
# either way by now it's a VM so now get the folder right
Get-Folder -Name $CurrentVTFolder2|Get-VM -Name $VM2bTemplate  >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Moving  $VM2bTemplate out of $CurrentVTFolder2"
 Get-VM -Name $VM2bTemplate | Move-VM -Destination $CurrentH1 -InventoryLocation  (Get-Datacenter -Name "$CurrentDataCenter") -Confirm:$false  >$null 2>&1
 Start-Sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="$VM2bTemplate VM is not in $CurrentVTFolder2"
 start-sleep 5
}
# Disconnect From vc
Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
$ProgressTextBox.text=""
$ProgressTextBox.BackColor="Green"
$ProgressTextBox.text= "Lab 16 Task 1 Undone"
# End of Module