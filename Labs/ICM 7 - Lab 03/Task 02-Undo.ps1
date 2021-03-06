# Module to create a vm
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Recreate a Virtual Machine)"
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
$CurrentCrVmDatastore="ICM-Datastore"
$ISODatastore = "ICM-Datastore"
# Connect to Host
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
Connect-VIServer -Server $CurrentH1 -User $CurrentH1User -Password $CurrentH1Pass  >$null 2>&1
Get-VMHost $CurrentH1 | Get-VM -name  $CurrentCrVmName  >$null 2>&1
if ($?)
{ $ProgressTextBox.text= "Virtual Machine $CurrentCrVmName is already recreated on $CurrentH1" }
else
{
$ProgressTextBox.text= "Recreate VM $CurrentCrVmName on $CurrentH1"
# a delay so the message can be seen
Start-sleep 1
Get-VMHost $CurrentH1 | New-VM -name  $CurrentCrVmName -DiskStorageFormat Thin -MemoryMB 1024 –DiskMB 12288 –Datastore $CurrentCrVmDatastore –NetworkName "VM Network" –GuestID windows9_64Guest -CD  >$null 2>&1
#wait for the create to settle
start-sleep 5
#connect cd
$ProgressTextBox.text= "Add WIndows 10 .ISO to VM $CurrentCrVmName"
# a delay so the message can be seen
Start-sleep 1
$curr_isopath = "["  + $ISODatastore + "] ISO/en_windows_10_enterprise_ltsc_2019_x64_dvd_5795bb03.iso"
Get-VM $CurrentCrVmName | Get-CDDrive | Set-CDDrive -IsoPath $curr_isopath -Confirm:$false >$null 2>&1
# let things settle 
Start-Sleep 1
Get-VM $CurrentCrVmName | Get-CDDrive | Set-CDDrive  -StartConnected $true -Confirm:$false >$null 2>&1
# let things settle 
Start-Sleep 1
# used to workout the guestid in line 29
#Get-VM $CurrentCrVmName |  Select-Object Name, @{n="ConfigdGuestId"; e={$_.ExtensionData.Config.GuestId}}, @{n="ConfigdGuestFullName"; e={$_.ExtensionData.Config.GuestFullName}}

#make sure it boots from cd
$value = "5000"
$ThisVM = get-vm $CurrentCrVmName
$ThisVMview = get-vm "$ThisVM" | get-view
$ThisVMConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
$ThisVMConfigSpec.BootOptions = New-Object VMware.Vim.VirtualMachineBootOptions
$ThisVMConfigSpec.BootOptions.BootDelay = $value
$ThisVMview.ReconfigVM_Task($ThisVMConfigSpec) >$null 2>&1
#boot VM after waiting for the settings to kick in
Start-Sleep 5
$ThisVM = get-vm $CurrentCrVmName
$ThisVMview = get-vm "$ThisVM" | get-view
$HDD1Key = ($ThisVMview.Config.Hardware.Device | ?{$_.DeviceInfo.Label -eq "Hard Disk 1"}).Key
$FlpKey =($ThisVMview.Config.Hardware.Device | ?{$_.DeviceInfo.Label -eq "Floppy drive 1"}).Key 
$bootHDD1 = New-Object -TypeName VMware.Vim.VirtualMachineBootOptionsBootableDiskDevice -Property @{"DeviceKey" = $HDD1Key}
$bootFlp = New-Object -Type Vmware.Vim.VirtualMachineBootOptionsBootableFloppyDevice # -Property @{"DeviceKey" = $FlpKey}
$BootCD = New-Object -Type VMware.Vim.VirtualMachineBootOptionsBootableCdromDevice
$spec = New-Object VMware.Vim.VirtualMachineConfigSpec -Property @{
        "BootOptions" = New-Object VMware.Vim.VirtualMachineBootOptions -Property @{
                BootOrder = $BootCD, $BootHDD1, $bootFlp
        }
}
$ThisVMview.ReconfigVM_Task($spec) >$null 2>&1
# let things settle 
Start-Sleep 1
#$ProgressTextBox.text= "Boot Order Set on VM $CurrentCrVmName"
# In this version of the Lab there's no actual install
#Start-vm -vm $CurrentCrVmName  -Confirm:$false
# let things settle 
Start-Sleep 1
}
Disconnect-VIServer -Server $CurrentH1 -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
$ProgressTextBox.text=""
$ProgressTextBox.BackColor="Green"
$ProgressTextBox.text= "Lab 3 Task 2 Undone"
# End of Module