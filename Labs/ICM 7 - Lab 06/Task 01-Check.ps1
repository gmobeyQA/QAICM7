# MODULE check Add vSphere Licenses to vCenter Server
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Add vSphere Licenses to vCenter Server)"
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

# Connect to vc
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
$vCenter = Connect-VIServer -Server $CurrectVC -User $CurrectVCUser -Password $CurrectVCPass # >$null 2>&1
$vcKey=""
$vSKey=""
$ThisLic=""
$vcKey=$vCenterLic.text;
$vSKey=$vSphereLic.text;
$CorrectVCLic=$false
$CorrectVsLic=$false
$licMgr = Get-View licensemanager
$TheLicences = $licMgr.Licenses
ForEach ($ThisLic in $TheLicences)
{
 if ($ThisLic.EditionKey -ne "eval")
 {
  #$ThisLic
  if ($ThisLic.EditionKey -eq "vc.standard.instance")
  {
   $ProgressTextBox.text="vCenter Standard Licence added is $($ThisLic.LicenseKey)"
   # a delay so the message can be seen
   Start-sleep 2
   if ($vcKey -eq $ThisLic.LicenseKey) {$CorrectVCLic=$true}
  }
  if ($ThisLic.EditionKey -eq "esx.enterprisePlus.cpuPackageCoreLimited")
  {
   $ProgressTextBox.text="vShere Enterprise Plus Licence added is $($ThisLic.LicenseKey)"
   # a delay so the message can be seen
   Start-sleep 2
   if ($vsKey -eq $ThisLic.LicenseKey) {$CorrectVsLic=$true}
  }
 }
}
#Disconnect From Host
Disconnect-VIServer -Server $CurrectVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null

if ($CorrectVCLic -and $CorrectVsLic)
{
$ProgressTextBox.BackColor = "Green"
$ProgressTextBox.text=  "Both the Licenses have been added to $CurrectVC"
}
else
{
$ProgressTextBox.text=""
if ($CorrectVCLic)
{$ProgressTextBox.text="Only the vSphere License has been added"}
elseif ($CorrectVsLic)
{$ProgressTextBox.text="Only the vCenter License has been added"}
else
{$ProgressTextBox.text=  "Neither of the Licenses have been added to $CurrectVC"}
# a delay so the message can be seen
Start-sleep 5
$ProgressTextBox.text=""
$ProgressTextBox.BackColor="Red"
$ProgressTextBox.text= "Redo Lab 6 Task 1"
}

# End of Module