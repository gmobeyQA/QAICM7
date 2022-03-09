# MODULE to Assign a License to the vCenter Server Instance
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Assign a License to the vCenter Server Instance)"
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
$CurrectVC="sa-vcsa-01.vclass.local"
$CurrectVCUser="administrator@vsphere.local"
$CurrectVCPass="VMware1!"
$CorrectVCLic=$false
$CorrectVsLic=$false

# Connect to vc
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
$vCenter = Connect-VIServer -Server $CurrectVC -User $CurrectVCUser -Password $CurrectVCPass # >$null 2>&1
$vcKey=""
$vSKey=""
$ThisLic=""
$licMgr = Get-View licensemanager
$TheLicences = $licMgr.Licenses
ForEach ($ThisLic in $TheLicences)
{
 if ($ThisLic.EditionKey -ne "eval")
 {
  #$ThisLic"
  if ($ThisLic.EditionKey -eq "vc.standard.instance")
  {
   $ProgressTextBox.text=""
   $ProgressTextBox.text="vCenter Standard Licence added is $($ThisLic.LicenseKey)"
   # a delay so the message can be seen
   Start-sleep 2
   $vcKey=$ThisLic.LicenseKey
   $CorrectVCLic=$true
  }

 }
}

if ($vcKey -eq "")
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="The vCenter License Has not been added"
 # a delay so the message can be seen
 Start-sleep 1
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Assign vCenter License $vcKey"
 # a delay so the message can be seen
 Start-sleep 5
 $LM = get-view($vCenter.ExtensionData.content.LicenseManager)
 $LAM = get-view($LM.licenseAssignmentManager)
 $LAM.UpdateAssignedLicense($vCenter.InstanceUuid,$vcKey,$Null)
}


#Disconnect From Host
Disconnect-VIServer -Server $CurrectVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
        
if ($CorrectVCLic)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text=  "The License $vcKey has been Assigned to $CurrectVC"
 # a delay so the message can be seen
 Start-sleep 5
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Green"
 $ProgressTextBox.text= "Lab 6 Task 2 Done"
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Red"
 $ProgressTextBox.text= "Redo Lab 6 Task 1... the vCenter License is missing"
}
# End of Module