# MODULE TO Create a Data Center Object
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Create a Data Center Object)"
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
$Curr_secondLun=6
$Current_SecondDatatoreName = "VMFS-3"

# Connect to vc
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
$vCenter = Connect-VIServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass # >$null 2>&1
 
$VMH1View = Get-VMHost $CurrentH1 | Get-View
$H1LunsByCanonicalName = Get-VMHost $CurrentH1 | Get-SCSILun
$H1LunsByKey = $VMH1View.Config.StorageDevice.ScsiTopology | 
		ForEach {$_.Adapter} | where {$_.Adapter -eq "key-vim.host.InternetScsiHba-vmhba65"} | ForEach {$_.Target} | ForEach {$_.Lun}
$tmpld1=$VMH1View.Config.StorageDevice.ScsiTopology | ForEach {$_.Adapter} | where {$_.Adapter -eq "key-vim.host.InternetScsiHba-vmhba65"} | ForEach {$_.Target} | ForEach {$_.Lun}|where {$_.Lun -eq $Curr_FirstLun}
$tmpld1[0]
$FirstLunDisk=$tmpld1[0]
$FirstLunsKey=$FirstLunDisk.Key.Replace("ScsiTopology.Lun", "ScsiDisk")
Get-ScsiLun -VMHost $CurrentH1 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $FirstLunsKey}| select CanonicalName,key
$firstscsilun = Get-ScsiLun -VMHost $CurrentH1 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $FirstLunsKey}
New-Datastore -VMHost $CurrentH1 -Name $Current_firstDatatoreName -Path $firstscsilun.CanonicalName -Vmfs -FileSystemVersion 6


$tmpld2=$VMH1View.Config.StorageDevice.ScsiTopology | ForEach {$_.Adapter} | where {$_.Adapter -eq "key-vim.host.InternetScsiHba-vmhba65"} | ForEach {$_.Target} | ForEach {$_.Lun}|where {$_.Lun -eq $Curr_SecondLun}
$SecondLunDisk=$tmpld2[0]
$SecondLunsKey=$SecondLunDisk.Key.Replace("ScsiTopology.Lun", "ScsiDisk")
Get-ScsiLun -VMHost $CurrentH1 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $SecondLunsKey}| select CanonicalName,key
$Secondscsilun = Get-ScsiLun -VMHost $CurrentH1 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $SecondLunsKey}	 
New-Datastore -VMHost $CurrentH1 -Name $Current_SecondDatatoreName -Path $Secondscsilun.CanonicalName -Vmfs -FileSystemVersion 6

# let things settle
sleep 1
Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
# End of Module

