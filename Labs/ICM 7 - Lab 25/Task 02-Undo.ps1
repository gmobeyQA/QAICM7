# MODULE Undo Modify vSphere DRS Settings
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
$DRSMigRate = 3

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
  $ProgressTextBox.text= "Cluster $CurrCluster already enabled for DRS"
  start-sleep 5
 }
 else
 {
  Set-Cluster -cluster $CurrCluster -DrsEnabled:$true -Confirm:$false
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Switching on DRS for Cluster $CurrCluster"
  start-sleep 5
 }
 if ($thisCluster.HAEnabled)
 {
  Set-Cluster -cluster $CurrCluster -HAEnabled:$false -Confirm:$false
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Switching off HA for Cluster $CurrCluster"
  start-sleep 5
 }
 
 if ($thisCluster.DrsMode -eq "Manual")
 {
  Set-Cluster -cluster $CurrCluster -DrsAutomationLevel "FullyAutomated" -Confirm:$false
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Setting Drs to FullyAutomated on Cluster $CurrCluster"
  start-sleep 5
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Drs is not Manual on Cluster $CurrCluster"
  start-sleep 5
 }
 if ($thisCluster.ExtensionData.ConfigurationEx.DrsConfig.VmotionRate -ne 3 )
 {
  $ClusView=$thisCluster| Get-View
  $clusSpec = New-Object VMware.Vim.ClusterConfigSpecEx
  $clusSpec.drsConfig = New-Object VMware.Vim.ClusterDrsConfigInfo
  $clusSPec.drsConfig.vmotionRate = $DRSMigRate
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Setting Drs to Middling on Cluster $CurrCluster"
  $ClusView.ReconfigureComputeResource_Task($clusSpec, $true)
  start-sleep 5
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Drs is already Middling on Cluster $CurrCluster"
  start-sleep 5
 }
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Green"
 $ProgressTextBox.text= "Lab 25 Task 1 Undone"
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
# End of Module