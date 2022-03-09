# MODULE TO Create a Folder for the ESXi Hosts
$ProgressTextBox.BackColor="Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Create a Folder for the ESXi Hosts)"
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
$CurrentHCFolder="Lab Servers"
$CurrentH1="sa-esxi-01.vclass.local"
$CurrentH1User="root"
$CurrentH1Pass="VMware1!"
$CurrentH2="sa-esxi-02.vclass.local"
$CurrentH2User="root"
$CurrentH2Pass="VMware1!"
# Connect to vc
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
$vCenter=Connect-VIServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass # >$null 2>&1
# The Datacenter needs to exist so let's check if it's there
# >$null 2>&1 hides the output
# $? true if it's found and false if it's not
Get-Datacenter -Name $CurrentDataCenter >$null 2>&1
if ($?)
{
 $ProgressTextBox.text="$CurrentDataCenter already exists"
 # a delay so the message can be seen
 Start-sleep 5
 # is the folder already there
 Get-Folder -Name $CurrentHCFolder  >$null 2>&1
 if ($?)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="$CurrentHCFolder exists below $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
  $FolderIs=$true
  Get-Folder -Name $CurrentHCFolder | Get-VMHost -name $CurrentH1 >$null 2>&1
  if ($?)
  {
   $ProgressTextBox.text=""
   $ProgressTextBox.text="$CurrentH1 is inside $CurrentHCFolder"
   # a delay so the message can be seen
   Start-sleep 5
   $h1is=$true
  }
  else
  {
   $ProgressTextBox.text=""
   $ProgressTextBox.text="$CurrentH1 is not inside $CurrentHCFolder"
   # a delay so the message can be seen
   Start-sleep 5
   $h1is=$false
  }
  Get-Folder -Name $CurrentHCFolder | Get-VMHost -name $CurrentH2 >$null 2>&1
  if ($?)
  {
   $ProgressTextBox.text=""
   $ProgressTextBox.text="$CurrentH2 is inside $CurrentHCFolder"
   # a delay so the message can be seen
   Start-sleep 5
   $h2is=$true
  }
  else 
  {
   $ProgressTextBox.text=""
   $ProgressTextBox.text="$CurrentH2 is not inside $CurrentHCFolder"
   # a delay so the message can be seen
   Start-sleep 5
   $h2is=$false
  }
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Redo Lab 7 Task 5 ... Folder $CurrentHCFolder has not been added to $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
  $FolderIs=$false
 }
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "Redo Lab 7 Task 1 ... Datacenter $CurrentDataCenter has not been added to $CurrentVC"
 # a delay so the message can be seen
 Start-sleep 5
}
#Disconnect From Host
Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer=$null
        $DefaultVIServers=$null
if ($h1is -and $h2is -and $FolderIs)
{
  $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Green"
 $ProgressTextBox.text= "All Steps of Lab 7 Task 5 Completed"
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Red"
 $ProgressTextBox.text= "Redo Lab 7 Task 5 ..."
}

# End of Module