# MODULE TO Create a Second VMFS Datastore
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Create a Second VMFS Datastore)"
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
$Curr_ThirdLun=5
$Current_ThirdDatatoreName = "iSCSI-Datastore"

# Connect to vc
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
$vCenter = Connect-VIServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass # >$null 2>&1
Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_ThirdDatatoreName >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Datastore $Current_ThirdDatatoreName already Created"
 # a delay so the message can be seen
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Creating Datastore $Current_ThirdDatatoreName"
 $VMH1View = Get-VMHost -Name $CurrentH1 | Get-View
 $H1LunsByCanonicalName = Get-VMHost $CurrentH1 | Get-SCSILun
 $H1LunsByKey = $VMH1View.Config.StorageDevice.ScsiTopology | 
		ForEach {$_.Adapter} | where {$_.Adapter -eq "key-vim.host.InternetScsiHba-vmhba65"} | ForEach {$_.Target} | ForEach {$_.Lun}
 $tmpldH1=$VMH1View.Config.StorageDevice.ScsiTopology | ForEach {$_.Adapter} | where {$_.Adapter -eq "key-vim.host.InternetScsiHba-vmhba65"} | ForEach {$_.Target} | ForEach {$_.Lun}|where {$_.Lun -eq $Curr_ThirdLun}
 $tmpldH1[0]
 $ThirdLunDisk=$tmpldH1[0]
 $ThirdLunsKey=$ThirdLunDisk.Key.Replace("ScsiTopology.Lun", "ScsiDisk")
 Get-ScsiLun -VMHost $CurrentH1 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $ThirdLunsKey}| select CanonicalName,key
 $Thirdscsilun = Get-ScsiLun -VMHost $CurrentH1 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $ThirdLunsKey}
 New-Datastore -VMHost $CurrentH1 -Name $Current_ThirdDatatoreName -Path $Thirdscsilun.CanonicalName -Vmfs -FileSystemVersion 6
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
$ProgressTextBox.text= "Lab 13 Task 5 Done"
# End of Module

