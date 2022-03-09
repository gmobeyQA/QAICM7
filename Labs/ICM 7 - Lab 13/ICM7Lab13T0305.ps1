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
$Curr_FirstLun=5
$Current_firstDatatoreName = "iSCSI-Datastore"

# Connect to VC
Connect-VIServer -Server $CurrectVC -User administrator@vsphere.local -Password "VMware1!" 
clear 
$VMHostView = Get-VMHost $current_host | Get-View
$HostLunsByCanonicalName = Get-VMHost $current_host | Get-SCSILun
$HostLunsByKey = $VMHostView.Config.StorageDevice.ScsiTopology | 
		ForEach {$_.Adapter} | where {$_.Adapter -eq "key-vim.host.InternetScsiHba-vmhba65"} | ForEach {$_.Target} | ForEach {$_.Lun}
$tmpld1=$VMHostView.Config.StorageDevice.ScsiTopology | ForEach {$_.Adapter}| where {$_.Adapter -eq "key-vim.host.InternetScsiHba-vmhba65"} | ForEach {$_.Target} | ForEach {$_.Lun}|where {$_.Lun -eq $Curr_FirstLun}
$tmpld1[0]
$FirstLunDisk=$tmpld1[0]
$FirstLunsKey=$FirstLunDisk.Key.Replace("ScsiTopology.Lun", "ScsiDisk")
Get-ScsiLun -VMHost $current_host -LunType disk | where {$_.Vendor -ne "VMware"}|select key, CapacityGB
where {$_.Key -like    $FirstLunsKey}| select CanonicalName,key
$firstscsilun = Get-ScsiLun -VMHost $current_host -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $FirstLunsKey}
New-Datastore -VMHost $current_host -Name $Current_firstDatatoreName -Path $firstscsilun.CanonicalName -Vmfs -FileSystemVersion 6

Disconnect-VIServer -Server $CurrectVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
# End of Module

