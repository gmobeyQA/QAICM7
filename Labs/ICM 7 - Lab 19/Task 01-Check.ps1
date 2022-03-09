# MODULE Check Configure vSphere vMotion Networking on sa-esxi-01.vclass.local
$ProgressTextBox.BackColor="Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Configure vSphere vMotion Networking on sa-esxi-01.vclass.local)"
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
$CurrentH2Pass="VMware1!"
$VMoStdvSwitch="vSwitch2"
$VMoNic="vmnic2"
$VMoVMPG="vMotion"
$VMoKpAddr = "172.20.12.51"
$VMoKpMask = "255.255.255.0"


# Connect to vc
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
$vCenter=Connect-VIServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass # >$null 2>&1

# create vSwitch and Connect it to vmnic
# does it exist already?
# >$null 2>&1 hides the output
# $? true if it's found and false if it's not
Get-VirtualSwitch -VMHost $CurrentH1 -Name $VMoStdvSwitch  >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="$VMoStdvSwitch exists"
 # a delay so the message can be seen
 Start-sleep 5
 $Current_switch = Get-VirtualSwitch -VMHost $CurrentH1 -Name $VMoStdvSwitch
 $thisNic=$Current_switch.Nic
 if ("$thisNic" -eq "")
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.BackColor="Red"
  $ProgressTextBox.text="$VMoNic is missing from $VMoStdvSwitch"
  # a delay so the message can be seen
  Start-sleep 5
 }
 elseif ("$thisNic" -eq "$VMoNic")
 {
  $ProgressTextBox.text="$VMoNic has been added to $VMoStdvSwitch"
  # a delay so the message can be seen
  Start-sleep 5
   Get-VMhost $CurrentH1|Get-VMHostNetworkAdapter -VMKernel -name 'vmk2'
 if ($?)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="vmk2 is added to $CurrentH1"
  start-sleep 5
  $ThisKnl=Get-VMhost $CurrentH1|Get-VMHostNetworkAdapter -VMKernel -name 'vmk2'
  if ($ThisKnl.IP -eq $VMoKpAddr)
  {
   $ProgressTextBox.text=""
   $ProgressTextBox.text="vmk2 has the correct IP Address"
   start-sleep 5
   if ($ThisKnl.SubnetMask -eq $VMoKpMask)
   {
    $ProgressTextBox.text=""
    $ProgressTextBox.text="vmk2 has the correct Subnet Mask"
    start-sleep 5
    if ($ThisKnl.VMotionEnabled)
    {
     $ProgressTextBox.text=""
     $ProgressTextBox.text="vmk2 has vMotion Enabled"
     start-sleep 5
     $ProgressTextBox.BackColor="Green"
     $ProgressTextBox.text=""
     $ProgressTextBox.text= "Lab 19 Task 1 Completed"
    }
    else
    {
     $ProgressTextBox.text=""
     $ProgressTextBox.BackColor="Red"
     $ProgressTextBox.text="vmk2 has vMotion Disabled"
     start-sleep 5
    }
   }
   else
   {
    $ProgressTextBox.text=""
    $ProgressTextBox.BackColor="Red"
    $ProgressTextBox.text="vmk2 has the incorrect Subnet Mask"
    start-sleep 5
   }
  }
  else
  {
   $ProgressTextBox.text=""
   $ProgressTextBox.BackColor="Red"
   $ProgressTextBox.text="vmk2 has the incorrect IP Address"
   start-sleep 5
  }
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.BackColor="Red"
  $ProgressTextBox.text="vmk2 is Missing from $CurrentH1"
 }
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.BackColor="Red"
  $ProgressTextBox.text="$thisNic incorrectly added to $VMoStdvSwitch"
 }
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Red"
 $ProgressTextBox.text="$VMoStdvSwitch is Missing from $CurrentH1"
 # a delay so the message can be seen
 Start-sleep 5
 }

# Disconnect From vc
Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
# End of Module