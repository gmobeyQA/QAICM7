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
clear

$CurrectVC="sa-vcsa-01.vclass.local"
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false

#host 1
$current_host="sa-esxi-01.vclass.local" 
$Curr_FirstLun=2
$Current_firstDatatoreName = "VMFS-2"
$Curr_secondLun=3
$Current_SecondDatatoreName = "VMFS-3"



# Connect to VC
Connect-VIServer -Server $CurrectVC -User administrator@vsphere.local -Password "VMware1!" 
clear  

$scHost = Get-VMHost $current_host

$esx = $scHost | get-View

$ds = get-Datastore -name $Current_SecondDatatoreName -VMhost $scHost | get-View 

$storSystem = Get-View $esx.ConfigManager.StorageSystem

$partInfo = $storSystem.RetrieveDiskPartitionInfo("/vmfs/devices/disks/" + $ds.info.vmfs.extent[0].DiskName)

$spec = new-Object VMware.Vim.VmfsDatastoreExtendSpec 
$spec.Extent = $ds.info.vmfs.extent 
$spec.DiskUuid = ($esx.Config.StorageDevice.ScsiLun | where {$_.DevicePath -like ("*" + $ds.Info.Vmfs.Extent[0].DiskName)}).Uuid
$spec.Partition = $partInfo[0].Spec

# Destroy datastore 
remove-Datastore -Datastore $Current_SecondDatatoreName -VMHost $scHost -confirm:$false 
start-Sleep -s 10 

# Add disk extent to datastore 
$dsToBeExtended = get-Datastore -name $Current_firstDatatoreName -VMhost $scHost | get-View 
$dsSystem = get-View $esx.configManager.DatastoreSystem 

$dsSystem.extendVmfsDatastore($dsToBeExtended.MoRef, $spec)


Disconnect-VIServer -Server $CurrectVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
# End of Module

