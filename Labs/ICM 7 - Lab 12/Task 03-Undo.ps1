# MODULE TO Add the iSCSI Software Adapter to an ESXi Host
$ProgressTextBox.BackColor="Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Add the iSCSI Software Adapter to an ESXi Hosth)"
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
$CurrentH1="sa-esxi-01.vclass.local"
$CurrentH1User="root"
$CurrentH1Pass="VMware1!"
$CurrentH2="sa-esxi-02.vclass.local"
$CurrentH2User="root"
$CurrentH2Pass="VMware1!"
$OldStdvSwitch="vSwitch0"
$IpStNic="vmnic3"
$IpStVMPG="IP Storage"
$IpStKpAddr = "172.20.10.62"
$IpStKpMask = "255.255.255.0"
# Connect to H2
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
Connect-VIServer -Server $CurrentH2 -User $CurrentH2User -Password $CurrentH2Pass  >$null 2>&1
start-sleep 2
$Current_Host_Context = Get-VMHost $CurrentH2
#Enable iSCSI
$hostStore=Get-VMHostStorage -VMHost $CurrentH2
Start-Sleep 1
if ($hostStore.SoftwareIScsiEnabled)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Disabling iSCSI on $CurrentH2"
 Get-VMHostStorage -VMHost $Current_Host_Context | Set-VMHostStorage -SoftwareIScsiEnabled $false
 # a delay so the message can be seen
  Start-Sleep 5
 Restart-VMHost -VMHost $CurrentH2 -Force -Confirm:$false 
 $ProgressTextBox.text="Please wait while $CurrentH2 reboots"
 Start-Sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="iSCSI is already disabled on $CurrentH2"
 # a delay so the message can be seen
  Start-Sleep 5
} 
Disconnect-VIServer -Server $CurrentH2 -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
$ProgressTextBox.BackColor="Green"
$ProgressTextBox.text=""
$ProgressTextBox.text= "Lab 12 Task 3 Undone"
# End of Module