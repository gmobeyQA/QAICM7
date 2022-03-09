# MODULE TO Extend a VMFS Datastore
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Extend a VMFS Datastore)"
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
$Current_firstDatatoreName2 = "Shared-VMFS"
$Current_firstDatatoreSizeGB=8
$Curr_secondLun=6
$Current_SecondDatatoreName = "VMFS-3"

# Connect to vc
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
$vCenter = Connect-VIServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass # >$null 2>&1  


#has lab 13 task 4 already happened
Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_firstDatatoreName2 >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Lab 13 task 4 already done... skipping tasks"
 start-sleep 5
}
else
{
Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_firstDatatoreName >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Datastore $Current_firstDatatoreName has been Created"
 # a delay so the message can be seen
 Start-sleep 5
 $thisDatastore=Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_firstDatatoreName |Select Name,CapacityGB,
    @{N='DateTime';E={Get-Date}},
    @{N='CanonicalName';E={$_.ExtensionData.Info.Vmfs.Extent[0].DiskName}},
    @{N='LUN';E={
        $esx = Get-View -Id $_.ExtensionData.Host[0].Key -Property Name
        $dev = $_.ExtensionData.Info.Vmfs.Extent[0].DiskName
        $esxcli = Get-EsxCli -VMHost $esx.Name -V2
        $esxcli.storage.nmp.path.list.Invoke(@{'device'=$dev}).RuntimeName.Split(':')[-1].TrimStart('L')}}
 if ($thisDatastore.LUN -eq $Curr_FirstLun)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Datastore $Current_firstDatatoreName Created with the correct Lun"
  # a delay so the message can be seen
  Start-sleep 5
  if ($thisDatastore.CapacityGB -lt $Current_firstDatatoreSizeGB)
  {
   $ProgressTextBox.BackColor="Red"
   $ProgressTextBox.text=""
   $ProgressTextBox.text="Not Expanded... Redo Lab 13 Task 2"
   # a delay so the message can be seen
   Start-sleep 5
  }
  else
  {
   $Labworked=$false
   $ProgressTextBox.text=""
   $ProgressTextBox.text="Datastore $Current_firstDatatoreName Expanded"
   # a delay so the message can be seen
   Start-sleep 5
   Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_SecondDatatoreName >$null 2>&1
   if ($?)
   {
    $ProgressTextBox.BackColor="Red"
    $ProgressTextBox.text=""
    $ProgressTextBox.text="Redo Lab 13 Task 3 $Current_SecondDatatoreName Still exists"
    # a delay so the message can be seen
    Start-sleep 6
   }
   else
   {
    # very time sensitive lots of delays needed
    $ProgressTextBox.text=""
    $ProgressTextBox.text="Extend $Current_firstDatatoreName with Lun $Curr_secondLun"
    #rename it first to save time
    Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_firstDatatoreName | Set-Datastore -Name $Current_firstDatatoreName2
    # it's easier to recreate the second lun to get it's spec
    $VMH1View = Get-VMHost -Name $CurrentH1 | Get-View
    $H1LunsByCanonicalName = Get-VMHost $CurrentH1 | Get-SCSILun
    $tmpldH1=$VMH1View.Config.StorageDevice.ScsiTopology | ForEach {$_.Adapter} | where {$_.Adapter -eq "key-vim.host.InternetScsiHba-vmhba65"} | ForEach {$_.Target} | ForEach {$_.Lun}|where {$_.Lun -eq $Curr_SecondLun}
    $SecondLunDisk=$tmpldH1[0]
    $SecondLunsKey=$SecondLunDisk.Key.Replace("ScsiTopology.Lun", "ScsiDisk")
    Get-ScsiLun -VMHost $CurrentH1 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $SecondLunsKey}| select CanonicalName,key
    $Secondscsilun = Get-ScsiLun -VMHost $CurrentH1 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $SecondLunsKey}	 
    New-Datastore -VMHost $CurrentH1 -Name $Current_SecondDatatoreName -Path $Secondscsilun.CanonicalName -Vmfs -FileSystemVersion 6
    # a delay To give it time to create
    Start-sleep 20
    $ThisHost = Get-VMHost $CurrentH1
    $ds = get-Datastore -name $Current_SecondDatatoreName -VMhost $ThisHost | get-View 
    $storSystem = Get-View $VMH1View.ConfigManager.StorageSystem
    $partInfo = $storSystem.RetrieveDiskPartitionInfo("/vmfs/devices/disks/" + $ds.info.vmfs.extent[0].DiskName)
    $spec = new-Object VMware.Vim.VmfsDatastoreExtendSpec 
    $spec.Extent = $ds.info.vmfs.extent 
    $spec.DiskUuid = ($VMH1View.Config.StorageDevice.ScsiLun | where {$_.DevicePath -like ("*" + $ds.Info.Vmfs.Extent[0].DiskName)}).Uuid
    $spec.Partition = $partInfo[0].Spec
    # let the system settle
    start-sleep 5
    # Destroy datastore
    Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_SecondDatatoreName|Remove-Datastore -VMHost $CurrentH1 -confirm:$false 
    start-Sleep 20
    # Add disk extent to datastore
    # refresh the variables
    $VMH1View = Get-VMHost -Name $CurrentH1 | Get-View
    $ThisHost = Get-VMHost $CurrentH1
    $dsToBeExtended = get-Datastore -name $Current_firstDatatoreName2 -VMhost $ThisHost | get-View 
    $dsSystem = get-View $VMH1View.configManager.DatastoreSystem
    $dsSystem.extendVmfsDatastore($dsToBeExtended.MoRef, $spec)
    $ProgressTextBox.BackColor="Green"
    $ProgressTextBox.text=""
    $ProgressTextBox.text="Lab 13 Task 4 Done"
   }
  }
 }
 else
 {
  $ProgressTextBox.BackColor="Red"
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Redo Lab 13 Task 1...  $Current_firstDatatoreName has incorrect Lun"
  # a delay so the message can be seen
  Start-sleep 5
 }
}
else
{
 $ProgressTextBox.BackColor="Red"
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Redo Lab 13 Task 1...  $Current_firstDatatoreName is Missing or Missnamed"
 # a delay so the message can be seen
 Start-sleep 5
}
}
Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
# End of Module

