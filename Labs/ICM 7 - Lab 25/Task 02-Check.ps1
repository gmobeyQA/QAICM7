# MODULE Check Modify vSphere DRS Settings
$ProgressTextBox.BackColor="Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Modify vSphere DRS Settings)"
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
$VM2Deploy1= "Photon-11"
$SharedDatastoreName="iSCSI-Datastore"
$OriginalDatastoreName="ICM-Datastore"
$CurrCluster="ICM-Compute-01"
$DRSMigRate = 1
$LabOk=$False

# Connect to vc
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
$vCenter=Connect-VIServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass # >$null 2>&1

Get-Cluster -Name $CurrCluster >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "Cluster $CurrCluster already exists"
 start-sleep 5
 $thisCluster=Get-Cluster -Name $CurrCluster #| select *
 if ($thisCluster.DrsEnabled)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Cluster $CurrCluster is enabled for DRS"
  start-sleep 5
  $LabOk=$True
  if ($thisCluster.HAEnabled)
  {
   $ProgressTextBox.text=""
   $ProgressTextBox.text= "Cluster $CurrCluster should not have HA Enabled"
   start-sleep 5
   $LabOk=$False
  }
  else
  {
   if ($thisCluster.DrsMode -ne "Manual")
   {
    $ProgressTextBox.text=""
    $ProgressTextBox.text= "Drs is not Manual on Cluster $CurrCluster"
    start-sleep 5
    $LabOk=$False
   }
   else
   {
    $ProgressTextBox.text=""
    $ProgressTextBox.text= "Drs is Manual on Cluster $CurrCluster"
    start-sleep 5
    if ($thisCluster.ExtensionData.ConfigurationEx.DrsConfig.VmotionRate -ne 1 )
    {
     $ProgressTextBox.text=""
     $ProgressTextBox.text= "Drs is not Agressive on Cluster $CurrCluster"
     start-sleep 5
     $LabOk=$False
    }
    else
    {
     $ProgressTextBox.text=""
     $ProgressTextBox.text= "Drs is already Agressive on Cluster $CurrCluster"
     start-sleep 5
    } 
   }
  }
 }
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= " Redo Lab 25 Task 1 ..Cluster $CurrCluster is Missing"
 start-sleep 5
 }

Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
if ($LabOk)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Green"
 $ProgressTextBox.text= "Lab 25 Task 2 Completed"
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Red"
 $ProgressTextBox.text= "Redo Lab 25 Task 2"
}
# End of Module