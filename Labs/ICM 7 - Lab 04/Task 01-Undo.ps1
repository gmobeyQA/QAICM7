# Module to Power Off and Close the Console to the VM
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Power Off and Close the Console to the VM)"
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
$CurrentTlVmName="Win10-Tools"
# Connect to Host
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
Connect-VIServer -Server $CurrentH1 -User $CurrentH1User -Password $CurrentH1Pass  >$null 2>&1
$Thisvm = Get-VM -Name $CurrentTlVmName
if ($Thisvm.PowerState -eq "PoweredOn")
{
# if we can try to shut it down otherwise power it off
if($Thisvm.Guest.State -eq "Running")
{
    $ProgressTextBox.text=""
    $ProgressTextBox.text=  "Shutdown VM $CurrentTlVmName"
    Shutdown-VMGuest -VM $Thisvm -Confirm:$false >$null 2>&1
    # a delay so the message can be seen
    Start-sleep 5
}
else
{
    $ProgressTextBox.text=""
    $ProgressTextBox.text=  "Power Off VM $CurrentTlVmName"
    Stop-VM -VM $Thisvm -Confirm:$false >$null 2>&
    # a delay so the message can be seen
    Start-sleep 11
}
}
else
{
$ProgressTextBox.text=""
$ProgressTextBox.text=  "VM $CurrentTlVmName is already Shutdown"
# a delay so the message can be seen
Start-sleep 5
}
$ProgressTextBox.text=""
$ProgressTextBox.text=  "Close Consoles for VM $CurrentTlVmName"
Get-Process -Name "vmrc"| where {$_.mainWindowTitle -and $_.mainWindowTitle -like "$($CurrentTlVmName)*"}| Stop-Process   >$null 2>&1
# let things settle 
Start-Sleep 5
Disconnect-VIServer -Server $CurrentH1 -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
$ProgressTextBox.text=""
$ProgressTextBox.BackColor="Green"
$ProgressTextBox.text= "Lab 4 Task 1 Undone"
# End of Module