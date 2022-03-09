﻿# MODULE Check Extend a VMFS Datastore
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Extend a VMFS Datastore)"
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
$Current_firstDatatoreName2 = "Shared-VMFS"
$Current_firstDatatoreSizeGB=8
$Curr_secondLun=6
$Current_SecondDatatoreName = "VMFS-3"
$Labworked=$True

# Connect to vc
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
$vCenter = Connect-VIServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass # >$null 2>&1



Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_firstDatatoreName2 >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Datastore $Current_firstDatatoreName has been Created"
 # a delay so the message can be seen
 Start-sleep 5
 $thisDatastore=Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_firstDatatoreName2 |Select Name,CapacityGB,
    @{N='LUN1';E={
        $esx = Get-View -Id $_.ExtensionData.Host[0].Key -Property Name
        $dev = $_.ExtensionData.Info.Vmfs.Extent[0].DiskName
        $esxcli = Get-EsxCli -VMHost $esx.Name -V2
        $esxcli.storage.nmp.path.list.Invoke(@{'device'=$dev}).RuntimeName.Split(':')[-1].TrimStart('L')}},
    @{N='LUN2';E={
        $esx = Get-View -Id $_.ExtensionData.Host[0].Key -Property Name
        $dev = $_.ExtensionData.Info.Vmfs.Extent[1].DiskName
        $esxcli = Get-EsxCli -VMHost $esx.Name -V2
        $esxcli.storage.nmp.path.list.Invoke(@{'device'=$dev}).RuntimeName.Split(':')[-1].TrimStart('L')}}
 if ($thisDatastore.LUN1 -eq $Curr_FirstLun)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Datastore $Current_firstDatatoreName Created with the correct first Lun"
  # a delay so the message can be seen
  Start-sleep 5
  if ($thisDatastore.LUN2 -eq $Curr_secondLun)
  {
   $ProgressTextBox.text=""
   $ProgressTextBox.text="Datastore $Current_firstDatatoreName Created with the correct second Lun"
   # a delay so the message can be seen
   Start-sleep 5
  }
  else
  {
  $Labworked=$false
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Datastore $Current_firstDatatoreName Created with an incorrect second Lun"
  # a delay so the message can be seen
  Start-sleep 5
  }
 }
 else
 {
  $Labworked=$false
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Datastore $Current_firstDatatoreName Created with an incorrect first Lun"
  # a delay so the message can be seen
  Start-sleep 5
 }
}
else
{
 $Labworked=$false
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Datastore $Current_firstDatatoreName is Missing or Misnamed"
 # a delay so the message can be seen
 Start-sleep 5
}


# let things settle
sleep 1
Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
if ($Labworked)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Green"
 $ProgressTextBox.text= "Lab 13 Task 4 Correctly Done"
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Red"
 $ProgressTextBox.text= "Redo Lab 13 Task 4"
}
# End of Module

