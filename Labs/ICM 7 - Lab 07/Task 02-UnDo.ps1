# MODULE undo Add ESXi Hosts to the Inventory
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Add ESXi Hosts to the Inventory)"
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
$CurrentH1="sa-esxi-01.vclass.local"
$CurrentH1User="root"
$CurrentH1Pass="VMware1!"
$CurrentH2="sa-esxi-02.vclass.local"
$CurrentH2User="root"
$CurrentH2Pass="VMware1!"
$CurrentH4="sa-esxi-04.vclass.local"
$CurrentH5="sa-esxi-05.vclass.local"
$CurrentH6="sa-esxi-06.vclass.local"
$CurrentDataCenter="ICM-Datacenter"
# Connect to vc
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
$vCenter = Connect-VIServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass # >$null 2>&1
#eval key
$CurVSLic="00000-00000-00000-00000-00000"
# The Datacenter probably exists so let's check if it's there
# >$null 2>&1 hides the output
# $? true if it's found and false if it's not
Get-Datacenter -Name $CurrentDataCenter >$null 2>&1
if ($?)
{       
 $ProgressTextBox.text=""
 $ProgressTextBox.text=  "Datacenter $CurrentDataCenter has been added to $CurrentVC"
 # a delay so the message can be seen
 Start-sleep 5
 #Remove H1
 Get-Datacenter -Name $CurrentDataCenter| Get-VMHost -Name $CurrentH1 >$null 2>&1
 if ($?)
 {       
  $ProgressTextBox.text=""
  $ProgressTextBox.text=  "Remove $CurrentH1 from Datacenter $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
  Get-VMHost -Name $CurrentH1 | Remove-VMHost -Confirm:$false >$null 2>&1
  Start-sleep 5
 }
 else
 {       
  $ProgressTextBox.text=""
  $ProgressTextBox.text=  "$CurrentH1 has already been removed from Datacenter $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
 }
 #Remove H2
 Get-Datacenter -Name $CurrentDataCenter| Get-VMHost -Name $CurrentH2 >$null 2>&1
 if ($?)
 {       
  $ProgressTextBox.text=""
  $ProgressTextBox.text=  "Remove $CurrentH2 from Datacenter $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
  Get-VMHost -Name $CurrentH2 | Remove-VMHost -Confirm:$false >$null 2>&1
  Start-sleep 5
 }
 else
 {       
  $ProgressTextBox.text=""
  $ProgressTextBox.text=  "$CurrentH2 has already been removed from Datacenter $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
 }
 # UnLicence pre-existing hosts while we're here
 Set-VMHost -VMHost $CurrentH4 -LicenseKey $CurVSLic >$null 2>&1
 Set-VMHost -VMHost $CurrentH5 -LicenseKey $CurVSLic >$null 2>&1
 Set-VMHost -VMHost $CurrentH6 -LicenseKey $CurVSLic >$null 2>&1
 Start-sleep 5
}
else
{       
 $ProgressTextBox.text=""
 $ProgressTextBox.text=  "$CurrentDataCenter has not been added to $CurrentVC so no Hosts to remove"
 # a delay so the message can be seen
 Start-sleep 5        
}        
$ProgressTextBox.text=""
$ProgressTextBox.text=  "Both Hosts Have been removed from Datacenter $CurrentDataCenter"
# a delay so the message can be seen
Start-sleep 5        
$ProgressTextBox.text=""
$ProgressTextBox.BackColor="Green"
$ProgressTextBox.text= "Lab 7 Task 2 Undone"
# let things settle
start-sleep 1
Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
# End of Module