# MODULE TO Create VMFS Datastores for the ESXi Host
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Create VMFS Datastores for the ESXi Host)"
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
$CurrentVC="sa-vcsa-01.vclass.local"
$CurrentVCUser="administrator@vsphere.local"
$CurrentVCPass="VMware1!"
$CurrentH1="sa-esxi-01.vclass.local"
$CurrentH1User="root"
$CurrentH1Pass="VMware1!"
$CurrentH2="sa-esxi-02.vclass.local"
$CurrentH2User="root" 
$Curr_FirstLun=2
$Current_firstDatatoreName = "VMFS-2"
$Current_firstDatatoreSizeGB=8
$Curr_secondLun=6
$Current_SecondDatatoreName = "VMFS-3"

# Connect to vc
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
$vCenter = Connect-VIServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass # >$null 2>&1
Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_firstDatatoreName >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Datastore $Current_firstDatatoreName already Created"
 # a delay so the message can be seen
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Creating Datastore $Current_firstDatatoreName"
 $VMH1View = Get-VMHost -Name $CurrentH1 | Get-View
 $H1LunsByCanonicalName = Get-VMHost $CurrentH1 | Get-SCSILun
 $H1LunsByKey = $VMH1View.Config.StorageDevice.ScsiTopology | 
		ForEach {$_.Adapter} | where {$_.Adapter -eq "key-vim.host.InternetScsiHba-vmhba65"} | ForEach {$_.Target} | ForEach {$_.Lun}
 $tmpldH1=$VMH1View.Config.StorageDevice.ScsiTopology | ForEach {$_.Adapter} | where {$_.Adapter -eq "key-vim.host.InternetScsiHba-vmhba65"} | ForEach {$_.Target} | ForEach {$_.Lun}|where {$_.Lun -eq $Curr_FirstLun}
 $tmpldH1[0]
 $FirstLunDisk=$tmpldH1[0]
 $FirstLunsKey=$FirstLunDisk.Key.Replace("ScsiTopology.Lun", "ScsiDisk")
 Get-ScsiLun -VMHost $CurrentH1 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $FirstLunsKey}| select CanonicalName,key
 $firstscsilun = Get-ScsiLun -VMHost $CurrentH1 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $FirstLunsKey}

 $H1View = Get-View -ViewType HostSystem -Filter @{'Name'=$CurrentH1}
 $hdSys = Get-View -Id $H1View.ConfigManager.DatastoreSystem
 $disk = $hdSys.QueryAvailableDisksForVmfs($null) | where{$_.CanonicalName -eq $firstscsilun.CanonicalName}
 $opt = $hdSys.QueryVmfsDatastoreCreateOptions($disk.DevicePath,$null)
 $sectorTotal = $Current_firstDatatoreSizeGB * 1GB / 512
 $FirstLunSpec = New-Object VMware.Vim.VmfsDatastoreCreateSpec
 $FirstLunSpec.DiskUuid = $disk.Uuid
 $FirstLunSpec.Partition = $opt[0].Spec.Partition
 $FirstLunSpec.Partition.Partition[0].EndSector = $FirstLunSpec.Partition.Partition[0].StartSector + $sectorTotal
 $FirstLunSpec.Partition.TotalSectors = $sectorTotal
 $FirstLunSpec.Vmfs = New-Object VMware.Vim.HostVmfsSpec
 $FirstLunSpec.Vmfs.VolumeName = $Current_firstDatatoreName
 $ThisExtent = New-Object VMware.Vim.HostScsiDiskPartition
 $ThisExtent.DiskName = $firstscsilun.CanonicalName
 $ThisExtent.Partition = $opt[0].Info.Layout.Partition[0].Partition
 $FirstLunSpec.Vmfs.Extent = $ThisExtent
 $FirstLunSpec.vmfs.MajorVersion = $opt[0].Spec.Vmfs.MajorVersion
 $hdSys.CreateVmfsDatastore($FirstLunSpec)

 #New-Datastore -VMHost $CurrentH1 -Name $Current_firstDatatoreName -Path $firstscsilun.CanonicalName -Vmfs -FileSystemVersion 6
 # a delay so the message can be seen
 Start-sleep 5
}

Get-VMHost -Name $CurrentH2 | Get-Datastore -Name $Current_SecondDatatoreName >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Datastore $Current_SecondDatatoreName already Created"
 # a delay so the message can be seen
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Creating Datastore $Current_SecondDatatoreName"
 $VMH2View = Get-VMHost -Name $CurrentH2 | Get-View
 $H2LunsByCanonicalName = Get-VMHost $Current21 | Get-SCSILun
 $tmpldH2=$VMH2View.Config.StorageDevice.ScsiTopology | ForEach {$_.Adapter} | where {$_.Adapter -eq "key-vim.host.InternetScsiHba-vmhba65"} | ForEach {$_.Target} | ForEach {$_.Lun}|where {$_.Lun -eq $Curr_SecondLun}
 $SecondLunDisk=$tmpldH2[0]
 $SecondLunsKey=$SecondLunDisk.Key.Replace("ScsiTopology.Lun", "ScsiDisk")
 Get-ScsiLun -VMHost $CurrentH2 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $SecondLunsKey}| select CanonicalName,key
 $Secondscsilun = Get-ScsiLun -VMHost $CurrentH2 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $SecondLunsKey}	 
 New-Datastore -VMHost $CurrentH2 -Name $Current_SecondDatatoreName -Path $Secondscsilun.CanonicalName -Vmfs -FileSystemVersion 6
 # a delay so the message can be seen
 Start-sleep 5
}
# let things settle
sleep 1
Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
$ProgressTextBox.text=""
$ProgressTextBox.BackColor="Green"
$ProgressTextBox.text= "Lab 13 Task 1 Done"
# End of Module

