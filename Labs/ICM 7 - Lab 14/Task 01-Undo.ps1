# MODULE Undo Configure Access to an NFS Datastore
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Configure Access to an NFS Datastore)"
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
$CurrentDataCenter="ICM-Datacenter"
$CurrentH1="sa-esxi-01.vclass.local"
$CurrentH1User="root"
$CurrentH1Pass="VMware1!"
$CurrentH2="sa-esxi-02.vclass.local"
$CurrentH2User="root" 
$Current_nfsDatastorename= "NFS-Datastore"
$Current_nfsPath = "/NFS-Data"
$Current_nfsHost = "172.20.10.10"

# Connect to vc
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
$vCenter = Connect-VIServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass # >$null 2>&1
# check both hosts
Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_nfsDatastorename >$null 2>&1
if ($?)
{$ProgressTextBox.text=""
 $ProgressTextBox.text="Removing Datastore $Current_nfsDatastorename from $CurrentH1"
 # a delay so the message can be seen
 Remove-Datastore -VMHost $CurrentH1 -Datastore $Current_nfsDatastorename -confirm:$false
 Start-sleep 5
}
else
{$ProgressTextBox.text=""
 $ProgressTextBox.text="Datastore $Current_nfsDatastorename already removed from $CurrentH1"
 # a delay so the message can be seen
 Start-sleep 5
}
Get-VMHost -Name $CurrentH2 | Get-Datastore -Name $Current_nfsDatastorename >$null 2>&1
if ($?)
{$ProgressTextBox.text=""
 $ProgressTextBox.text="Removing Datastore $Current_nfsDatastorename from $CurrentH2"
 # a delay so the message can be seen
 Remove-Datastore -VMHost $CurrentH2 -Datastore $Current_nfsDatastorename -confirm:$false
 Start-sleep 5
}
else
{$ProgressTextBox.text=""
 $ProgressTextBox.text="Datastore $Current_nfsDatastorename already removed from $CurrentH2"
 # a delay so the message can be seen
 Start-sleep 5
}
sleep 1
Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
$ProgressTextBox.text=""
$ProgressTextBox.BackColor="Green"
$ProgressTextBox.text= "Lab 14 Task 1 Undone"
# End of Module

