# MODULE TO Expand a VMFS Datastore to Consume Unused Space on a LUN
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Expand a VMFS Datastore to Consume Unused Space on a LUN)"
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
 $ProgressTextBox.text="Datastore $Current_firstDatatoreName Created"
 # a delay so the message can be seen
 Start-sleep 5
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Expand Datastore $Current_firstDatatoreName"
 $Thisdatastore = get-datastore $Current_firstDatatoreName
 $ThisEsxi = Get-View -Id ($Thisdatastore.ExtensionData.Host |Select-Object -last 1 | Select -ExpandProperty Key)
 $datastoreSystem = Get-View -Id $ThisEsxi.ConfigManager.DatastoreSystem
 $expandOptions = $datastoreSystem.QueryVmfsDatastoreExpandOptions($Thisdatastore.ExtensionData.MoRef)
 $datastoreSystem.ExpandVmfsDatastore($Thisdatastore.ExtensionData.MoRef,$expandOptions.spec)
 # a delay so the message can be seen
 Start-sleep 5
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Green"
 $ProgressTextBox.text= "Lab 13 Task 1 Done"
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Red"
 $ProgressTextBox.text="Redo Lab 13 Task 1 ... Datastore $Current_firstDatatoreName Missing"
 # a delay so the message can be seen
 Start-sleep 5
}

# let things settle
sleep 1
Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
# End of Module

