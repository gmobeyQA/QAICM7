# MODULE TO Add a VMkernel Port Group to a Standard Switch
$ProgressTextBox.BackColor="Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Add a VMkernel Port Group to a Standard Switch)"
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
$OldStdvSwitch="vSwitch0"
$IpStNic="vmnic3"
$IpStVMPG="IP Storage"
$IpStKpAddr = "172.20.10.62"
$IpStKpMask = "255.255.255.0"
# Connect to H2
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
Connect-VIServer -Server $CurrentH2 -User $CurrentH2User -Password $CurrentH2Pass  >$null 2>&1
# Get Context of vSwitch0
$Current_Switch = Get-VirtualSwitch -VMHost $CurrentH2 -Name $OldStdvSwitch
# Create the "IP Storage" Port Group
Get-VirtualSwitch -VMHost $CurrentH2 -Name $OldStdvSwitch| Get-VirtualPortGroup -Name $IpStVMPG   >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="$IpStVMPG is already added to $OldStdvSwitch"
 # a delay so the message can be seen
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Adding $IpStVMPG to $OldStdvSwitch"
 # a delay so the message can be seen
 Start-sleep 5
 # Get Context of Newly Created Switch
 $Current_switch = Get-VirtualSwitch -VMHost $CurrentH2 -Name $OldStdvSwitch
 #Create the Port Group Called Production
 $current_Port_Group = New-VirtualPortGroup -VirtualSwitch $Current_switch -Name $IpStVMPG
 Start-Sleep 1
}
# Turn the VMPG Into a Kernel Port
$ProgressTextBox.text=""
$ProgressTextBox.text="Adding the Kernel Port to $IpStVMPG"
# a delay so the message can be seen
Start-sleep 5
Get-VMHostNetworkAdapter -VMHost $CurrentH2 -VMKernel -name 'vmk1'  >$null 2>&1
if ($?)
{
 # Turn the Kernel Port Into a VMPG
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Kernel Port vmk1 already added to $IpStVMPG"
 # a delay so the message can be seen
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Adding the Kernel Port vmk1 to $IpStVMPG"
 # a delay so the message can be seen
 Start-sleep 5
 New-VMHostNetworkAdapter -VMHost $CurrentH2 -PortGroup $IpStVMPG -VirtualSwitch $Current_Switch -IP $IpStKpAddr -SubnetMask $IpStKpMask
 Start-sleep 5
}
Disconnect-VIServer -Server $CurrentH2 -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
$ProgressTextBox.BackColor="Green"
$ProgressTextBox.text=""
$ProgressTextBox.text= "Lab 12 Task 2 Done"
# End of Module