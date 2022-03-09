# MODULE TO Connect the iSCSI Software Adapters to Storage
$ProgressTextBox.BackColor="Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Connect the iSCSI Software Adapters to Storage)"
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
$CurrentH1="sa-esxi-01.vclass.local"
$CurrentH1User="root"
$CurrentH1Pass="VMware1!"
$CurrentH2="sa-esxi-02.vclass.local"
$CurrentH2User="root"
$CurrentH2Pass="VMware1!"
$OldStdvSwitc="vSwitch0"
$IpStNic="vmnic3"
$IpStVMPG="IP Storage"
$IpStKpAddr = "172.20.10.62"
$IpStKpMask = "255.255.255.0"
$IpStiSCSItgt="172.20.10.15"
# Connect to H2
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
Connect-VIServer -Server $CurrentH2 -User $CurrentH2User -Password $CurrentH2Pass  >$null 2>&1
#Get Software iSCSI adapter HBA number and put it into an array
$HBA = Get-VMHostHba -VMHost $CurrentH2 -Type iSCSI | %{$_.Device}
#Set your VMKernel numbers, Use ESXCLI to create the iSCSI Port binding in the iSCSI Software Adapter,
$vmk1number = 'vmk1'
$esxcli = Get-EsxCli -VMhost $CurrentH2
$Esxcli.iscsi.networkportal.add($HBA, $Null, $vmk1number) 
#Setup the Discovery iSCSI IP addresses on the iSCSI Software Adapter
$hbahost = get-vmhost $CurrentH2 | get-vmhosthba -type iscsi
$thistgt=get-iscsihbatarget -iscsihba $hbahost -Type Send
if ($thistgt.Address -eq $IpStiSCSItgt)
{
$ProgressTextBox.text="Send Targets Address is already set to $IpStiSCSItgt"
# a delay so the message can be seen
Start-sleep 5
if ($thistgt.Port -eq "3260")
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Send Targets Address is already set to 3260"
 # a delay so the message can be seen
 Start-sleep 5
}
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Setting Send Targets"
 new-iscsihbatarget -iscsihba $hbahost -address $IpStiSCSItgt  >$null 2>&1
 # a delay so the message can be seen
 Start-sleep 5
}
#Rescan the HBA to discover any storage
get-vmhoststorage $CurrentH2 -rescanallhba -rescanvmfs
# Rescan to pick up targets and storage
Start-sleep 3
Get-VMHostStorage -VMHost $CurrentH2 -RescanAllHba -RescanVmfs
Start-sleep 3	 
Disconnect-VIServer -Server $CurrentH2 -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
$ProgressTextBox.text=""
$ProgressTextBox.BackColor="Green"
$ProgressTextBox.text= "Lab 12 Task 4 Done"
# End of Module