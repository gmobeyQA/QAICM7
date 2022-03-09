# MODULE Undo Create a Standard Switch with a Virtual Machine Port Group
$ProgressTextBox.BackColor="Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Create a Standard Switch with a Virtual Machine Port Group)"
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
$CurrVM1="Win10-02"
$CurrVM2="Win10-04"
$CurrVM3="Win10-06"
$NewStdvSwitch="vSwitch1"
$NewStdvSwNic="vmnic3"
$NewStdvSwVMPG="Production"
# Connect to H1
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
Connect-VIServer -Server $CurrentH1 -User $CurrentH1User -Password $CurrentH1Pass  >$null 2>&1
# create vSwitch1 and Connect it to vmnic3
# does it exist already?
# >$null 2>&1 hides the output
# $? true if it's found and false if it's not
Get-VirtualSwitch -VMHost $CurrentH1 -Name $NewStdvSwitch  >$null 2>&1
if ($?)
{
 $ProgressTextBox.text="Removing $NewStdvSwitch from $CurrentH1"
 # a delay so the message can be seen
 Start-sleep 5
 Remove-VirtualSwitch -VirtualSwitch (Get-VirtualSwitch -VMHost $CurrentH1 -Name $NewStdvSwitch) -Confirm:$false
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="$NewStdvSwitch is already removed from $CurrentH1"
 # a delay so the message can be seen
 Start-sleep 5
 }
# Disconnect From H1
Disconnect-VIServer -Server $CurrentH1 -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
# Connect to H2
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
Connect-VIServer -Server $CurrentH2 -User $CurrentH2User -Password $CurrentH2Pass  >$null 2>&1
# create vSwitcH2 and Connect it to vmnic3
# does it exist already?
# >$null 2>&1 hides the output
# $? true if it's found and false if it's not
Get-VirtualSwitch -VMHost $CurrentH2 -Name $NewStdvSwitch  >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Removing $NewStdvSwitch from $CurrentH2"
 # a delay so the message can be seen
 Start-sleep 5
 Remove-VirtualSwitch -VirtualSwitch (Get-VirtualSwitch -VMHost $CurrentH2 -Name $NewStdvSwitch) -Confirm:$false
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="$NewStdvSwitch is already removed from $CurrentH2"
 # a delay so the message can be seen
 Start-sleep 5
 }
# Disconnect From H2
Disconnect-VIServer -Server $CurrentH2 -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
$ProgressTextBox.BackColor="Green"
$ProgressTextBox.text=""
$ProgressTextBox.text= "Lab 11 Task 2 Undone"
# End of Module