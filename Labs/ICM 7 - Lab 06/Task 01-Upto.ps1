# MODULE TO Get Ready for Lab 6 Task 1
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Get Ready for Lab 6 Task 1)"
# a delay so the message can be seen
Start-sleep 1
# (Generic) Add The Powershell cmdlets - library old Powershell Add-PSSnapin new Powershell Import-Module
#Add-PSSnapin -Name VMware.VimAutomation.Core -ea SilentlyContinue 	# automated administration of the vSphere environment.
#Add-PSSnapin -Name VMware.VimAutomation.License -ea SilentlyContinue 	# Provides the Get-LicenseDataManager cmdlet for managing VMware License components
#Add-PSSnapin -Name VMware.ImageBuilder -ea SilentlyContinue		# managing depots, image profiles, and VIBs.
#Add-PSSnapin -Name VMware.VimAutomation.DeployAutomation -ea SilentlyContinue	# provide an interface to VMware Auto Deploy for provisioning physical hosts with ESXi software
Import-Module VMware.VimAutomation.Core				        # automated administration of the vSphere environment.
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
$CurrentDomain="vclass.local"
$CurrentDUser="administrator"
$CurrentDPass="VMware1!"
$TheSvc="TSM","TSM-SSH"
$CurrentCrVmName="Win10-Empty"
$CurrentTlVmName="Win10-Tools"
$CurrentHwVmName="Photon-Hw"
# Connect to Host
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
Connect-VIServer -Server $CurrentH1 -User $CurrentH1User -Password $CurrentH1Pass  >$null 2>&1

$CurrAuth=Get-VMHostAuthentication -VMHost $CurrentH1 -Server $CurrentH1
$CurrentAuthD=$CurrAuth.Domain
if ("$CurrentAuthD" -notlike "VCLASS.LOCAL")
{
        $ProgressTextBox.text = "Adding AD Domain Authentication to $CurrentH1"
        $CurrAuth|Set-VMHostAuthentication -Domain $CurrentDomain -JoinDomain -Username $CurrentDUser -Password $CurrentDPass -Confirm:$false
        # let things settle
        Start-Sleep 1
        $ProgressTextBox.text = ""
        $ProgressTextBox.text = "$CurrentH1 is now Authenticating against AD Domain $CurrentDomain"
}
else
{
        $ProgressTextBox.text = ""
        $ProgressTextBox.text = "$CurrentH1 is already Authenticating against AD Domain $CurrentDomain"
}
# let things settle 
Start-Sleep 1
foreach ($CurrSvc in $TheSvc)
{
        $AllServices = Get-VMHostService
        $ThisService = $AllServices | Where-Object {$_.Key -eq $CurrSvc}
        if ($ThisService.running -eq $true)
        {
            $ProgressTextBox.text=""
            $ProgressTextBox.text="$CurrSvc is already Started on Host $CurrentH1"
            # a delay so the message can be seen
            Start-sleep 5
        }
        else
        {
            $ProgressTextBox.text=""
            $ProgressTextBox.text="Starting $CurrSvc on host $CurrentH1"
            # a delay so the message can be seen
            Start-sleep 5
            Start-VMHostService -HostService (Get-VMHost | Get-VMHostService  | Where { $_.Key -eq $CurrSvc }) >$null 2>&1
            $ProgressTextBox.text=""
            $ProgressTextBox.text="Started $CurrSvc on host $CurrentH1"
            # a delay so the message can be seen
            Start-sleep 5
        }
}
# let things settle 
Start-Sleep 1
# just in case this in't run on a vanilla environment
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
# let things settle 
Start-Sleep 1
# just in case this in't run on a vanilla environment
$Thisvm = Get-VM -Name $CurrentTlVmName
if ($Thisvm.PowerState -eq "PoweredOn")
{
# if we can try to shut it down otherwise power it off
if($Thisvm.Guest.State -eq "Running")
{
    $ProgressTextBox.text=  "Shutdown Virtual Machine $CurrentTlVmName"
    # a delay so the message can be seen
    Start-sleep 1
    Shutdown-VMGuest -VM $Thisvm -Confirm:$false >$null 2>&1
}
else
{
    $ProgressTextBox.text=  "Power Off Virtual Machine $CurrentTlVmName"
    # a delay so the message can be seen
    Start-sleep 1
    Stop-VM -VM $Thisvm -Confirm:$false >$null 2>&1
}
}
else
{
$ProgressTextBox.text=  "Virtual Machine $CurrentTlVmName is already Shutdown"
# a delay so the message can be seen
Start-sleep 1
}
$ProgressTextBox.text=  "Close Consoles for VM $CurrentTlVmName"
# a delay so the message can be seen
Start-sleep 1
Get-Process -Name "vmrc" >$null 2>&1
if ($?) {Get-Process -Name "vmrc"| where {$_.mainWindowTitle -and $_.mainWindowTitle -like "$($CurrentTlVmName)*"}| Stop-Process   >$null 2>&1}
# let things settle 
Start-Sleep 1
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
$Thisvm = Get-VM -Name $CurrentHwVmName
$VmsDisks=($Thisvm| select name, @{N="TotalHDD"; E={($_ | Get-HardDisk).count }})
if ($VmsDisks.TotalHDD -gt 1)
{
$ProgressTextBox.text=""
$ProgressTextBox.text= "Additional disks already Added to VM $CurrentHwVmName"
# a delay so the message can be seen
Start-sleep 2
}
else
{
$ProgressTextBox.text=""
$ProgressTextBox.text= "Add 1GB Thin provisioned disk to VM $CurrentHwVmName"
$Thisvm | New-HardDisk -CapacityGB 1 -StorageFormat Thin  -Confirm:$false # >$null 2>&1
# a delay so the message can be seen
Start-sleep 5
$Thisvm = Get-VM -Name $CurrentHwVmName
$ProgressTextBox.text=""
$ProgressTextBox.text= "Add 1GB Thick provisioned, eagerly zeroed disk to VM $CurrentHwVmName"
# a delay so the message can be seen
Start-sleep 5
$Thisvm | New-HardDisk -CapacityGB 1 -StorageFormat EagerZeroedThick  -Confirm:$false # >$null 2>&1
# let things settle 
Start-Sleep 2
Get-HardDisk -VM $CurrentHwVmName | ForEach-Object {
$HardDisk=$_
if ($HardDisk.Name -ne "Hard disk 1")
{ 
$ProgressTextBox.text=""
$ProgressTextBox.text= $CurrentHwVmName+" '"+$HardDisk.Name+"' size is "+$HardDisk.CapacityGB+" GB"
# a delay so the message can be seen
Start-sleep 5
$ProgressTextBox.text=""
$ProgressTextBox.text= $CurrentHwVmName+" '"+$HardDisk.Name+"' size is Provisioned as: "+$HardDisk.StorageFormat
# a delay so the message can be seen
Start-sleep 5
}
}
$ProgressTextBox.text=""
$ProgressTextBox.text= "The 2 disks Added to VM $CurrentHwVmName"
# a delay so the message can be seen
Start-sleep 5
}
$Thisvm = Get-VM -Name $CurrentHwVmName
if ($Thisvm.PowerState -eq "PoweredOn")
{
# if we can try to shut it down otherwise power it off
if($Thisvm.Guest.State -eq "Running")
{
    $ProgressTextBox.text=  "Shutdown Virtual Machine $CurrentHwVmName"
    # a delay so the message can be seen
    Start-sleep 1
    Shutdown-VMGuest -VM $Thisvm -Confirm:$false >$null 2>&1
}
else
{
    $ProgressTextBox.text=  "Power Off Virtual Machine $CurrentHwVmName"
    # a delay so the message can be seen
    Start-sleep 1
    Stop-VM -VM $Thisvm -Confirm:$false >$null 2>&1
}
}
else
{
$ProgressTextBox.text=  "Virtual Machine $CurrentHwVmName is already Shutdown"
# a delay so the message can be seen
Start-sleep 1
}
$ProgressTextBox.text=  "Close Consoles for VM $CurrentHwVmName"
# a delay so the message can be seen
Start-sleep 1
Get-Process -Name "vmrc" >$null 2>&1
if ($?) {Get-Process -Name "vmrc"| where {$_.mainWindowTitle -and $_.mainWindowTitle -like "$($CurrentHwVmName)*"}| Stop-Process   >$null 2>&1}
# let things settle 
Start-Sleep 1
Disconnect-VIServer -Server $CurrentH1 -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
$ProgressTextBox.text=""
$ProgressTextBox.BackColor="Green"
$ProgressTextBox.text= "Ready For Lab 6 Task 1"
# End of Module