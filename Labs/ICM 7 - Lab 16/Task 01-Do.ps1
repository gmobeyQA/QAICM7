# MODULE TO Create a Virtual Machine Template
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
$ProgressTextBox.text=""
$ProgressTextBox.text="Change $VM2bTemplate VM to Template and move to folder Lab Templates"
Get-Template -Name $VM2bTemplate >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="$VM2bTemplate VM has already been turned into a Template"
 # is it in the correct folder
 Get-Folder -Name $CurrentVTFolder2|Get-Template -Name $VM2bTemplate  >$null 2>&1
 if ($?)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="The Template is already in the folder $CurrentVTFolder2"
 }
}
else
{
 $thisVM=Get-VM -Name $VM2bTemplate
 if ($thisVM.PowerState -ne "PoweredOff")
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Powering Down $VM2bTemplate"
  # if the command works
  Shutdown-VMGuest -VM $VM2bTemplate -Confirm:$false >$null 2>&1
  if ($?){Start-Sleep 30}
  else
  {
   Stop-VM -VM $VM2bTemplate -Confirm:$false >$null 2>&1
   Start-Sleep 20
  }
 }
 Get-VM -Name $VM2bTemplate | Move-VM -Destination $CurrentH1 -InventoryLocation  (Get-Folder -Name $CurrentVTFolder2) -Confirm:$false  >$null 2>&1
 Start-Sleep 5
 Set-VM -VM $VM2bTemplate -ToTemplate -Confirm:$false
 Start-Sleep 1
}
# Disconnect From vc
Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
$ProgressTextBox.text=""
$ProgressTextBox.BackColor="Green"
$ProgressTextBox.text= "Lab 16 Task 1 Done"

# End of Module