# Module to Examine a Virtual Machine's Configuration
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Examine a Virtual Machine's Configuration)"
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
$CurrentHwVmName="Photon-Hw"
# Connect to Host
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
Connect-VIServer -Server $CurrentH1 -User $CurrentH1User -Password $CurrentH1Pass  >$null 2>&1
$Thisvm = Get-VM -Name $CurrentHwVmName
if ($Thisvm.PowerState -ne "PoweredOn")
{
$ProgressTextBox.text=  "Boot VM $CurrentHwVmName"
# a delay so the message can be seen
Start-sleep 1
$Thisvm | Start-VM -Confirm:$false  >$null 2>&1
# let things settle 
Start-Sleep 1
}
else
{
$ProgressTextBox.text=  "VM $CurrentHwVmName is already Booted"
# a delay so the message can be seen
Start-sleep 2
}
Get-HardDisk -VM $CurrentHwVmName | ForEach-Object {
$HardDisk=$_
if ($HardDisk.Name -eq "Hard disk 1")
{ 
$ProgressTextBox.text= $CurrentHwVmName+" '"+$HardDisk.Name+"' size is "+$HardDisk.CapacityGB+" GB"
# a delay so the message can be seen
Start-sleep 2
$ProgressTextBox.text= $CurrentHwVmName+" '"+$HardDisk.Name+"' size is Provisioned as: "+$HardDisk.StorageFormat
# a delay so the message can be seen
Start-sleep 2
}
}
$ProgressTextBox.text= $CurrentHwVmName+" uses "+$Thisvm.ProvisionedSpaceGB+" GB of storage space"
# a delay so the message can be seen
Start-sleep 2
$guest=($Thisvm | Get-View).Guest
$ToolsStatus = ($Thisvm | Get-View).Guest.ToolsStatus 
If ($guest.ToolsStatus -eq "toolsNotInstalled" )
{
$ProgressTextBox.text="" 
$ProgressTextBox.text= "VMware Tools are not installed in $CurrentHwVmName"
}
Else
{
$ProgressTextBox.text=""
$ProgressTextBox.text=  "VMware Tools are installed in $CurrentHwVmName"
} 
# a delay so the message can be seen
Start-sleep 2
If ($guest.ToolsRunningStatus -eq "guestToolsRunning" )
{
$ProgressTextBox.text="" 
$ProgressTextBox.text= "VMware Tools are running in $CurrentHwVmName"
}
Else
{
$ProgressTextBox.text=""
$ProgressTextBox.text=  "VMware Tools are not running in in $CurrentHwVmName"
}
# a delay so the message can be seen
Start-sleep 5
Disconnect-VIServer -Server $CurrentH1 -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
$ProgressTextBox.text=""
$ProgressTextBox.BackColor="Green"
$ProgressTextBox.text= "Lab 5 Task 1 Done"
# End of Module