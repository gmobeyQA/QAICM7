# Module to Add Virtual Hard Disks to the Virtual Machine
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Add Virtual Hard Disks to the Virtual Machine)"
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
Disconnect-VIServer -Server $CurrentH1 -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
$ProgressTextBox.text=""
$ProgressTextBox.BackColor="Green"
$ProgressTextBox.text= "Lab 5 Task 2 Done"
# End of Module