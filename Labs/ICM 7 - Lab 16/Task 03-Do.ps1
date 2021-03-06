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
$CurrentH1="sa-esxi-01.vclass.local"
$CurrentH2="sa-esxi-02.vclass.local"
$VM2bTemplate = "Photon-Template"
$Cust_Spec = "Photon-CustomSpec"
$DnsSvr = "172.20.10.10"
$CstSpecDom="vclass.local"
$SharedDatastoreName="iSCSI-Datastore"
$DeplTemplate="Photon-Template"
$VM2Deploy1= "Photon-11"
$VM2Deploy2= "Photon-12"


# Connect to vc
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
$vCenter=Connect-VIServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass # >$null 2>&1
$ThisVMFolder=Get-Folder | where {$_.Name -like 'lab*vms'}
$ProgressTextBox.text=""
$ProgressTextBox.text= "Create the 2 VMs"
start-sleep 5
Get-VM -Name $VM2Deploy1 >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "$VM2Deploy1 already Exists"
 start-sleep 5
 $crVM1=$false
}
else
{
 $crVM1=$true
 # First Deploy
 $task01=New-VM -Name $VM2Deploy1 -Template $DeplTemplate -VMHost $CurrentH1 -Datastore $SharedDatastoreName -OSCustomizationSpec $Cust_Spec -Location ($ThisVMFolder) -RunAsync
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "Deploying $VM2Deploy1"
 start-sleep 5
}
# allow them to overlap
Get-VM -Name $VM2Deploy2 >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "$VM2Deploy2 already Exists"
 start-sleep 5
 $crVM2=$false
}
else
{
 $crVM2=$true
 #Second Deploy
 $task02=New-VM -Name $VM2Deploy2 -Template $DeplTemplate -VMHost $CurrentH2 -Datastore $SharedDatastoreName -OSCustomizationSpec $Cust_Spec -Location ($ThisVMFolder) -RunAsync
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "Deploying $VM2Deploy2"
 start-sleep 5
}
if ($crVM1)
{
 while($task01.ExtensionData.Info.State -eq "running"){
  sleep 1
  $task01.ExtensionData.UpdateViewData('Info.State')
 }
 # Only start them once deployed
}
#one way or another thy're here
$Thisvm = Get-VM -Name $VM2Deploy1
if ($Thisvm.PowerState -ne "PoweredOn")
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "Boot $VM2Deploy1"
 # a delay so the message can be seen
 Start-sleep 1
 $Thisvm | Start-VM -Confirm:$false  >$null 2>&1
 # let things settle 
 Start-Sleep 2
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text=  "VM $VM2Deploy1 is already Booted"
 # a delay so the message can be seen
 Start-sleep 5
}
while($task02.ExtensionData.Info.State -eq "running"){
  sleep 1
  $task02.ExtensionData.UpdateViewData('Info.State')
}
$Thisvm = Get-VM -Name $VM2Deploy2
if ($Thisvm.PowerState -ne "PoweredOn")
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "Boot $VM2Deploy2"
 # a delay so the message can be seen
 Start-sleep 1
 $Thisvm | Start-VM -Confirm:$false  >$null 2>&1
 # let things settle 
 Start-Sleep 2
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text=  "VM $VM2Deploy2 is already Booted"
 # a delay so the message can be seen
 Start-sleep 5
}
Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
$ProgressTextBox.text=""
$ProgressTextBox.BackColor="Green"
$ProgressTextBox.text= "Lab 16 Task 3 Done"
# End of Module
