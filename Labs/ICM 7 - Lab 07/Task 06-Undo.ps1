# MODULE undo Create Folders for VMs and VM Templates
$ProgressTextBox.BackColor="Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Create Folders for VMs and VM Templates)"
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
$CurrentH1User="root"
$CurrentH1Pass="VMware1!"
$CurrentH2="sa-esxi-02.vclass.local"
$CurrentH2User="root"
$CurrentH2Pass="VMware1!"
$CurrVM1="Win10-02"
$CurrVM2="Win10-04"
$CurrVM3="Win10-06"
# Connect to vc
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
$vCenter=Connect-VIServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass # >$null 2>&1 
# The Datacenter needs to exist so let's check if it's there
# >$null 2>&1 hides the output
# $? true if it's found and false if it's not
Get-Datacenter -Name $CurrentDataCenter >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="$CurrentDataCenter already exists"
 # a delay so the message can be seen
 Start-sleep 5
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Remove $CurrVM1 from folder $CurrentVTFolder1"
 # a delay so the message can be seen
 Start-sleep 5
 # move vm1
 Get-VM -Name $CurrVM1 | Move-VM -Destination $CurrentH1 -InventoryLocation (Get-Datacenter -Name "$CurrentDataCenter") -Confirm:$false  >$null 2>&1
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Remove $CurrVM2 from folder $CurrentVTFolder1"
 # a delay so the message can be seen
 Start-sleep 5
 # move vm3
 Get-VM -Name $CurrVM2 | Move-VM -Destination $CurrentH1 -InventoryLocation  (Get-Datacenter -Name "$CurrentDataCenter") -Confirm:$false  >$null 2>&1
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Remove $CurrVM3 from folder $CurrentVTFolder1"
 # a delay so the message can be seen
 Start-sleep 5
 # move vm1
 Get-VM -Name $CurrVM3 | Move-VM -Destination $CurrentH1 -InventoryLocation (Get-Datacenter -Name "$CurrentDataCenter") -Confirm:$false  >$null 2>&1
 # is the folder there
 Get-Folder -Name $CurrentVTFolder2  >$null 2>&1
 if ($?)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="remove $CurrentVTFolder2 from $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
  Remove-Folder -Folder $CurrentVTFolder2 -Confirm:$false  >$null 2>&1
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="VMs & Templates Folder $CurrentVTFolder2 already removed from  $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
 }
 # is the folder there
 Get-Folder -Name $CurrentVTFolder1  >$null 2>&1
 if ($?)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="remove $CurrentVTFolder1 from $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
  Remove-Folder -Folder $CurrentVTFolder1 -Confirm:$false  >$null 2>&1
 }
 else
 {
 $ProgressTextBox.text=""
  $ProgressTextBox.text="VMs & Templates Folder $CurrentVTFolder1 already removed from  $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
 }
 $ProgressTextBox.BackColor="Green"
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "Lab 7 Task 6 Undone"
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Red"
 $ProgressTextBox.text= "Redo Lab 7 Task 1 ... Datacenter $CurrentDataCenter has not been added to $CurrentVC"
}
#Disconnect From Host
Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer=$null
        $DefaultVIServers=$null
# End of Module