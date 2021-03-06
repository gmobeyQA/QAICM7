#Module to add nfs Datastore
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


$Current_nfsDatastorename= "NFS-Datastore"
$Current_nfsPath = "/NFS-Data"

# Connect to VC
Connect-VIServer -Server $CurrectVC -User administrator@vsphere.local -Password "VMware1!"

$current_host="sa-esxi-01.vclass.local" 
New-Datastore -Nfs -VMHost $current_host -Name $Current_nfsDatastorename -Path $Current_nfsPath -NfsHost 172.20.10.10 | Out-Null
$current_host="sa-esxi-02.vclass.local" 
New-Datastore -Nfs -VMHost $current_host -Name $Current_nfsDatastorename -Path $Current_nfsPath -NfsHost 172.20.10.10 | Out-Null
	 
Disconnect-VIServer -Server $CurrectVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
# End of Module


