# MODULE TO Add ESXi Hosts to the Cluster
$ProgressTextBox.BackColor="Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Add ESXi Hosts to the Cluster)"
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

# Connect to vc
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
$vCenter=Connect-VIServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass # >$null 2>&1
# The Datacenter needs to exist so let's check if it's there
# >$null 2>&1 hides the output
# $? true if it's found and false if it's not
Get-Datacenter -Name $CurrentDataCenter >$null 2>&1



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
 
 if ($thisCluster.DrsMode -ne "Manual")
 {
  Set-Cluster -cluster $CurrCluster -DrsAutomationLevel "Manual" -Confirm:$false
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Setting Drs to Manual on Cluster $CurrCluster"
  start-sleep 5
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Drs is already Manual on Cluster $CurrCluster"
  start-sleep 5
 }
 if ($thisCluster.ExtensionData.ConfigurationEx.DrsConfig.VmotionRate -ne 1 )
 {
  $ClusView=$thisCluster| Get-View
  $clusSpec = New-Object VMware.Vim.ClusterConfigSpecEx
  $clusSpec.drsConfig = New-Object VMware.Vim.ClusterDrsConfigInfo
  $clusSPec.drsConfig.vmotionRate = $DRSMigRate
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Setting Drs to Agressive on Cluster $CurrCluster"
  $ClusView.ReconfigureComputeResource_Task($clusSpec, $true)
  start-sleep 5
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Drs is already Agressive on Cluster $CurrCluster"
  start-sleep 5
 }
      Get-Cluster -Name $CurrCluster | Get-VMHost -name $CurrentH1 >$null 2>&1
     if ($?)
     {
      $ProgressTextBox.text=""
      $ProgressTextBox.text="$CurrentH1 is already inside $CurrCluster"
      # a delay so the message can be seen
      Start-sleep 5
     }
     else
     {
      $ProgressTextBox.text=""
      $ProgressTextBox.text="Put $CurrentH1 into Cluster $CurrCluster"
      # move h1
      Move-VMHost -VMHost $CurrentH1 -Destination $CurrCluster -Confirm:$false  >$null 2>&1
      # a delay so the message can be seen
      Start-sleep 5
     }
     Get-Cluster -Name $CurrCluster | Get-VMHost -name $CurrentH2 >$null 2>&1
     if ($?)
     {
      $ProgressTextBox.text=""
      $ProgressTextBox.text="$CurrentH2 is already inside $CurrCluster"
      # a delay so the message can be seen
      Start-sleep 5
     }
     else 
     {
      $ProgressTextBox.text=""
      $ProgressTextBox.text="Put $CurrentH2 into Cluster $CurrCluster"
      # move h2
      Move-VMHost -VMHost $CurrentH2 -Destination $CurrCluster -Confirm:$false  >$null 2>&1
      # a delay so the message can be seen
      Start-sleep 5
     }
  $ProgressTextBox.text=""
  $ProgressTextBox.BackColor="Green"
  $ProgressTextBox.text= "Lab 25 Task 3 Done"
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= " Redo Lab 25 Task 1 ..Cluster $CurrCluster is Missing"
 start-sleep 5
 }
#Disconnect From Host
Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer=$null
        $DefaultVIServers=$null
# End of Module