# Module undo Clean Up Lab 4
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Clean Up Lab 4)"
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
$ProgressTextBox.text=  "Stop any exsisting VMRC Consoles for $CurrentVmName"
# a delay so the message can be seen
Start-sleep 1
Get-Process -Name "vmrc"| where {$_.mainWindowTitle -and $_.mainWindowTitle -like "$($CurrentVmName)*"}| Stop-Process   >$null 2>&1
# Connect to Host
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
Connect-VIServer -Server $CurrentH -User $CurrentHUser -Password $CurrentHPass  >$null 2>&1
$moduleName = 'VMware.VimAutomation.Core'
$module = Get-Module -Name $moduleName -ListAvailable
$vmrcPath = "C:\Program Files (x86)\VMware\VMware Remote Console\vmrc.exe"
$Thisvm = Get-VM -Name $CurrentVmName
if ($Thisvm.PowerState -ne "PoweredOn")
{
$ProgressTextBox.text=  "Boot VM $CurrentVmName"
# a delay so the message can be seen
Start-sleep 1
$Thisvm | Start-VM -Confirm:$false  >$null 2>&1
# let things settle 
Start-Sleep 1
}
else
{
$ProgressTextBox.text=  "Virtual Machine $CurrentVmName is already Booted"
# a delay so the message can be seen
Start-sleep 1
}
$ProgressTextBox.text=  "Open Console for VM $CurrentVmName"
# a delay so the message can be seen
Start-sleep 1
$mks = $Thisvm.ExtensionData.AcquireMksTicket()
$parm = "vmrc://$($Thisvm.VMHost.Name):902/?mksticket=$($mks.Ticket)&thumbprint=$($mks.SslThumbPrint)&path=$($mks.CfgFile)"
& "$vmrcPath" $parm
# let things settle 
Start-Sleep 1
Disconnect-VIServer -Server $CurrentH -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class Win32 {
  [DllImport("User32.dll", EntryPoint="SetWindowText")]
  public static extern int SetWindowText(IntPtr hWnd, string strTitle);
}
"@
Get-Process -Name "vmrc"| where {$_.mainWindowTitle -and $_.mainWindowTitle -like "$($CurrentVmName)*"}| %{ [Win32]::SetWindowText($_.mainWindowHandle, "$CurrentVmName - VMware Remote Console")}
$ProgressTextBox.BackColor = "Green"
$ProgressTextBox.text=  "VM $CurrentVmName Powered On and has its Console Window Open"
# End of Module