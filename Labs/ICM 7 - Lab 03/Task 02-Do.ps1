# Module to remove a vm
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Remove a Virtual Machine)"
# a delay so the message can be seen
Start-sleep 1
# (Generic) Add The Powershell cmdlets - library old Powershell Add-PSSnapin new Powershell Import-Module
#Add-PSSnapin -Name VMware.VimAutomation.Core -ea SilentlyContinue 	# automated administration of the vSphere environment.
#Add-PSSnapin -Name VMware.VimAutomation.License -ea SilentlyContinue 	# Provides the Get-LicenseDataManager cmdlet for managing VMware License components
#Add-PSSnapin -Name VMware.ImageBuilder -ea SilentlyContinue		# managing depots, image profiles, and VIBs.
#Add-PSSnapin -Name VMware.VimAutomation.DeployAutomation -ea SilentlyContinue	# provide an interface to VMware Auto Deploy for provisioning physical hosts with ESXi software
Import-Module VMware.VimAutomation.Core		>$null 2>&1	        # automated administration of the vSphere environment.
#Import-Module VMware.VimAutomation.Vds				        # managing virtual distributed switches and port groups
#Import-Module VMware.VimAutomation.Cis.Core		                # managing vCloud Suite SDK servers
#Import-Module VMware.VimAutomation.Storage			        # managing vSphere policy-based storage
#Import-Module VMware.VimAutomation.HA				        # Provides the Get-DRMInfo cmdlet for retrieving Distributed Resource Management dump information
#Import-Module VMware.VimAutomation.Cloud
#Import-Module VMware.VimAutomation.PCloud
Clear-Host
# Using Variables to make changes easier
$CurrentH1="sa-esxi-01.vclass.local"
$CurrentH1User="root"
$CurrentH1Pass="VMware1!"
$CurrentCrVmName="Win10-Empty"
# Connect to Host
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
Connect-VIServer -Server $CurrentH1 -User $CurrentH1User -Password $CurrentH1Pass  >$null 2>&1
Get-VMHost $CurrentH1 | Get-VM -name  $CurrentCrVmName  >$null 2>&1
if ($?)
{
$ProgressTextBox.text=""
$ProgressTextBox.text= "Remove VM $CurrentCrVmName from $CurrentH1"
# a delay so the message can be seen
Start-sleep 1
#just in case someone booted it
Get-VMHost $CurrentH1 | Get-VM -name  $CurrentCrVmName | Stop-VM  -confirm:$false  >$null 2>&1
# let things settle 
Start-Sleep 10
# Now remove it
Get-VMHost $CurrentH1 | Get-VM -name  $CurrentCrVmName | Remove-VM -DeletePermanently -confirm:$false  >$null 2>&1
# let things settle
Start-Sleep 1
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "Virtual Machine $CurrentCrVmName is already removed from $CurrentH1"
}
Disconnect-VIServer -Server $CurrentH1 -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
$ProgressTextBox.text=""
$ProgressTextBox.BackColor="Green"
$ProgressTextBox.text= "Lab 3 Task 2 Done"
# End of Module