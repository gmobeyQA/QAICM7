# Module to Check VMware Tools are Installed
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Check VMware Tools are Installed)"
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
$CurrentH="sa-esxi-01.vclass.local"
$CurrentHUser="root"
$CurrentHPass="VMware1!"
$CurrentVmName="Win10-Tools"
$AnyConsoles=Get-Process -Name "vmrc"| where {$_.mainWindowTitle -and $_.mainWindowTitle -like "$($CurrentVmName)*"}
Get-Process -Id $AnyConsoles.id  >$null 2>&1
if ($?)
{
$ProgressTextBox.text=  "Good, the console is Open for Virtual Machine $CurrentVmName"
# a delay so the message can be seen
Start-sleep 2
# Connect to Host
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
Connect-VIServer -Server $CurrentH -User $CurrentHUser -Password $CurrentHPass  >$null 2>&1
$Thisvm = Get-VM -Name $CurrentVmName
if ($Thisvm.PowerState -ne "PoweredOn")
{
$ProgressTextBox.BackColor = "Red"
$ProgressTextBox.text= "Redo Lab 4 Task 2 ... Virtual Machine $CurrentVmName is not Running"
}
else
{
$ProgressTextBox.text=  "Good, Virtual Machine $CurrentVmName is still Running"
Start-sleep 2
$ToolsStatus = ($Thisvm | Get-View).Guest.ToolsStatus 
If ( $ToolsStatus -eq "toolsNotInstalled" )
{ 
$ProgressTextBox.BackColor = "Red"
$ProgressTextBox.text= "Redo Lab 4 Task 2 ... VMware Tools are not installed in $CurrentVmName"
}
Else
{
$ProgressTextBox.BackColor = "Green"
$ProgressTextBox.text=  "VMware Tools are installed in $CurrentVmName"
} 
}
Start-sleep 1
Disconnect-VIServer -Server $CurrentH -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
}
else
{
$ProgressTextBox.BackColor = "Red"
$ProgressTextBox.text=  "Redo Lab 4 Task 2 ... there is No Open Console for Virtual Machine $CurrentVmName"
}
# End of Module