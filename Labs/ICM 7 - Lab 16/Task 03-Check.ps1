# MODULE Check Create a Virtual Machine Template
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
$crVM1=$false
$crVM2=$false
$offVM1=$false
$offVM2=$false
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
 $Thisvm = Get-VM -Name $VM2Deploy1
 if ($Thisvm.PowerState -eq "PoweredOff")
 {
  $offVM1=$true
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "$VM2Deploy1 needs to be booted"
  # a delay so the message can be seen
  start-sleep 5
 }
 else
 {
  $offVM1=$false
  $ProgressTextBox.text=""
  $ProgressTextBox.text=  "VM $VM2Deploy1 is already Booted"
  # a delay so the message can be seen
  start-sleep 5
 }
}
else
{
 $crVM1=$true
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "$VM2Deploy1 is missing"
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
 $Thisvm = Get-VM -Name $VM2Deploy2
 if ($Thisvm.PowerState -eq "PoweredOff")
 {
  $offVM2=$true
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "$VM2Deploy2 needs to be booted"
  # a delay so the message can be seen
  start-sleep 5
 }
 else
 {
  $offVM2=$false
  $ProgressTextBox.text=""
  $ProgressTextBox.text=  "VM $VM2Deploy2 is already Booted"
  # a delay so the message can be seen
  start-sleep 5
 }
}
else
{
 $crVM2=$true
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "$VM2Deploy2 Is Missing"
 start-sleep 5
}

Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
if ($crVM1 -or $crVM2 -or $offVM1 -or $offVM2)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Red"
 $ProgressTextBox.text="Redoo Lab16 Task3... $VM2Deploy1 "
 if ($crVM1)
 {$ProgressTextBox.text=$ProgressTextBox.text+"Missing, "}
 else
 {
  $ProgressTextBox.text=$ProgressTextBox.text+"Exists, "
  if ($offVM1)
  {$ProgressTextBox.text=$ProgressTextBox.text+"But Powered off, $VM2Deploy2 " }
  else
  {$ProgressTextBox.text=$ProgressTextBox.text+"and is Powered on, $VM2Deploy2 " }
 }
 if ($crVM2)
 {$ProgressTextBox.text=$ProgressTextBox.text+"Missing."}
 else
 {
  $ProgressTextBox.text=$ProgressTextBox.text+"Exists, "
  if ($offVM2)
  {$ProgressTextBox.text=$ProgressTextBox.text+"But Powered off." }
  else
  {$ProgressTextBox.text=$ProgressTextBox.text+"and is Powered on." }
 }

}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Green"
 $ProgressTextBox.text= "Lab 16 Task 3 Completed"
}
# End of Module
