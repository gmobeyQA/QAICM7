﻿# MODULE TO Get Ready for Lab 9 Task 1
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Get Ready for Lab 9 Task 1)"
# a delay so the message can be seen
Start-sleep 1
# (Generic) Add The Powershell cmdlets - library old Powershell Add-PSSnapin new Powershell Import-Module
#Add-PSSnapin -Name VMware.VimAutomation.Core -ea SilentlyContinue 	# automated administration of the vSphere environment.
#Add-PSSnapin -Name VMware.VimAutomation.License -ea SilentlyContinue 	# Provides the Get-LicenseDataManager cmdlet for managing VMware License components
#Add-PSSnapin -Name VMware.ImageBuilder -ea SilentlyContinue		# managing depots, image profiles, and VIBs.
#Add-PSSnapin -Name VMware.VimAutomation.DeployAutomation -ea SilentlyContinue	# provide an interface to VMware Auto Deploy for provisioning physical hosts with ESXi software
Import-Module VMware.VimAutomation.Core				        # automated administration of the vSphere environment.
#Import-Module VMware.VimAutomation.Vds				        # managing virtual distributed switches and port groups
#Import-Module VMware.VimAutomation.Cis.Core		                # managing vCloud Suite SDK servers
#Import-Module VMware.VimAutomation.Storage			        # managing vSphere policy-based storage
#Import-Module VMware.VimAutomation.HA				        # Provides the Get-DRMInfo cmdlet for retrieving Distributed Resource Management dump information
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
$CurrentH4="sa-esxi-04.vclass.local"
$CurrentH5="sa-esxi-05.vclass.local"
$CurrentH6="sa-esxi-06.vclass.local"
$CurrentDomain="vclass.local"
$CurrentDUser="administrator"
$CurrentDPass="VMware1!"
$TheSvc="TSM","TSM-SSH"
$CurrentCrVmName="Win10-Empty"
$CurrentTlVmName="Win10-Tools"
$CurrentHwVmName="Photon-Hw"
$CurrentNTP="172.20.10.10"
$CurrentVC="sa-vcsa-01.vclass.local"
$CurrentVCUser="administrator@vsphere.local"
$CurrentVCPass="VMware1!"
$CurrentVCLocUser="root"
$CurrentVCLocPass="VMware1!"
$CorrectVCLic=$false
$CorrectVsLic=$false
$CurrentDataCenter="ICM-Datacenter"
$CurrentHCFolder="Lab Servers"
$CurrentVTFolder1="Lab VMs"
$CurrentVTFolder2="Lab Templates"
$CurrVM1="Win10-02"
$CurrVM2="Win10-04"
$CurrVM3="Win10-06"
$CurrentADDomain="vclass.local"
$CurrentADDomainU="administrator@vclass.local"
$CurrentADDomainP="VMware1!"
$CurrStdvSwitch="vSwitch1"
$CurrStdvSwNic="vmnic3"
$CurrStdvSwVMPG="Production" 

# Connect to Host
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
Connect-VIServer -Server $CurrentH1 -User $CurrentH1User -Password $CurrentH1Pass  >$null 2>&1

$CurrAuth=Get-VMHostAuthentication -VMHost $CurrentH1 -Server $CurrentH1
$CurrentAuthD=$CurrAuth.Domain
if ("$CurrentAuthD" -notlike "VCLASS.LOCAL")
{
        $ProgressTextBox.text = "Adding AD Domain Authentication to $CurrentH1"
        $CurrAuth|Set-VMHostAuthentication -Domain $CurrentDomain -JoinDomain -Username $CurrentDUser -Password $CurrentDPass -Confirm:$false
        # let things settle
        Start-Sleep 1
        $ProgressTextBox.text = ""
        $ProgressTextBox.text = "$CurrentH1 is now Authenticating against AD Domain $CurrentDomain"
}
else
{
        $ProgressTextBox.text = ""
        $ProgressTextBox.text = "$CurrentH1 is already Authenticating against AD Domain $CurrentDomain"
}
# let things settle 
Start-Sleep 1
foreach ($CurrSvc in $TheSvc)
{
        $AllServices = Get-VMHostService
        $ThisService = $AllServices | Where-Object {$_.Key -eq $CurrSvc}
        if ($ThisService.running -eq $true)
        {
            $ProgressTextBox.text=""
            $ProgressTextBox.text="$CurrSvc is already Started on Host $CurrentH1"
            # a delay so the message can be seen
            Start-sleep 5
        }
        else
        {
            $ProgressTextBox.text=""
            $ProgressTextBox.text="Starting $CurrSvc on host $CurrentH1"
            # a delay so the message can be seen
            Start-sleep 5
            Start-VMHostService -HostService (Get-VMHost | Get-VMHostService  | Where { $_.Key -eq $CurrSvc }) >$null 2>&1
            $ProgressTextBox.text=""
            $ProgressTextBox.text="Started $CurrSvc on host $CurrentH1"
            # a delay so the message can be seen
            Start-sleep 5
        }
}
# let things settle 
Start-Sleep 1
# just in case this in't run on a vanilla environment
Get-VMHost $CurrentH1 | Get-VM -name  $CurrentCrVmName  >$null 2>&1
if ($?)
{
$ProgressTextBox.text=""
$ProgressTextBox.text= "Remove VM $CurrentCrVmName from $CurrentH1"
# a delay so the message can be seen
Start-sleep 1
#just in case someone booted it
Get-VMHost $CurrentH1 | Get-VM -name  $CurrentCrVmName | Stop-VM  -confirm:$false  >$null 2>&1
# let things settle 
Start-Sleep 10
# Now remove it
Get-VMHost $CurrentH1 | Get-VM -name  $CurrentCrVmName | Remove-VM -DeletePermanently -confirm:$false  >$null 2>&1
# let things settle
Start-Sleep 1
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "Virtual Machine $CurrentCrVmName is already removed from $CurrentH1"
}
# let things settle 
Start-Sleep 1
# just in case this in't run on a vanilla environment
$Thisvm = Get-VM -Name $CurrentTlVmName
if ($Thisvm.PowerState -eq "PoweredOn")
{
# if we can try to shut it down otherwise power it off
if($Thisvm.Guest.State -eq "Running")
{
    $ProgressTextBox.text=  "Shutdown Virtual Machine $CurrentTlVmName"
    # a delay so the message can be seen
    Start-sleep 1
    Shutdown-VMGuest -VM $Thisvm -Confirm:$false >$null 2>&1
}
else
{
    $ProgressTextBox.text=  "Power Off Virtual Machine $CurrentTlVmName"
    # a delay so the message can be seen
    Start-sleep 1
    Stop-VM -VM $Thisvm -Confirm:$false >$null 2>&1
}
}
else
{
$ProgressTextBox.text=  "Virtual Machine $CurrentTlVmName is already Shutdown"
# a delay so the message can be seen
Start-sleep 1
}
$ProgressTextBox.text=  "Close Consoles for VM $CurrentTlVmName"
# a delay so the message can be seen
Start-sleep 1
Get-Process -Name "vmrc"  >$null 2>&1
if ($?) {Get-Process -Name "vmrc"| where {$_.mainWindowTitle -and $_.mainWindowTitle -like "$($CurrentTlVmName)*"}| Stop-Process   >$null 2>&1}
# let things settle 
Start-Sleep 1
$Thisvm = Get-VM -Name $CurrentHwVmName
if ($Thisvm.PowerState -ne "PoweredOn")
{
$ProgressTextBox.text=  "Boot VM $CurrentHwVmName"
# a delay so the message can be seen
Start-sleep 1
$Thisvm | Start-VM -Confirm:$false  >$null 2>&1
# let things settle 
Start-Sleep 1
}
else
{
$ProgressTextBox.text=  "VM $CurrentHwVmName is already Booted"
# a delay so the message can be seen
Start-sleep 2
}
Get-HardDisk -VM $CurrentHwVmName | ForEach-Object {
$HardDisk=$_
if ($HardDisk.Name -eq "Hard disk 1")
{ 
$ProgressTextBox.text= $CurrentHwVmName+" '"+$HardDisk.Name+"' size is "+$HardDisk.CapacityGB+" GB"
# a delay so the message can be seen
Start-sleep 2
$ProgressTextBox.text= $CurrentHwVmName+" '"+$HardDisk.Name+"' size is Provisioned as: "+$HardDisk.StorageFormat
# a delay so the message can be seen
Start-sleep 2
}
}
$ProgressTextBox.text= $CurrentHwVmName+" uses "+$Thisvm.ProvisionedSpaceGB+" GB of storage space"
# a delay so the message can be seen
Start-sleep 2
$guest=($Thisvm | Get-View).Guest
$ToolsStatus = ($Thisvm | Get-View).Guest.ToolsStatus 
If ($guest.ToolsStatus -eq "toolsNotInstalled" )
{
$ProgressTextBox.text="" 
$ProgressTextBox.text= "VMware Tools are not installed in $CurrentHwVmName"
}
Else
{
$ProgressTextBox.text=""
$ProgressTextBox.text=  "VMware Tools are installed in $CurrentHwVmName"
} 
# a delay so the message can be seen
Start-sleep 2
If ($guest.ToolsRunningStatus -eq "guestToolsRunning" )
{
$ProgressTextBox.text="" 
$ProgressTextBox.text= "VMware Tools are running in $CurrentHwVmName"
}
Else
{
$ProgressTextBox.text=""
$ProgressTextBox.text=  "VMware Tools are not running in in $CurrentHwVmName"
}
# a delay so the message can be seen
Start-sleep 5
$Thisvm = Get-VM -Name $CurrentHwVmName
$VmsDisks=($Thisvm| select name, @{N="TotalHDD"; E={($_ | Get-HardDisk).count }})
if ($VmsDisks.TotalHDD -gt 1)
{
$ProgressTextBox.text=""
$ProgressTextBox.text= "Additional disks already Added to VM $CurrentHwVmName"
# a delay so the message can be seen
Start-sleep 2
}
else
{
$ProgressTextBox.text=""
$ProgressTextBox.text= "Add 1GB Thin provisioned disk to VM $CurrentHwVmName"
$Thisvm | New-HardDisk -CapacityGB 1 -StorageFormat Thin  -Confirm:$false # >$null 2>&1
# a delay so the message can be seen
Start-sleep 5
$Thisvm = Get-VM -Name $CurrentHwVmName
$ProgressTextBox.text=""
$ProgressTextBox.text= "Add 1GB Thick provisioned, eagerly zeroed disk to VM $CurrentHwVmName"
# a delay so the message can be seen
Start-sleep 5
$Thisvm | New-HardDisk -CapacityGB 1 -StorageFormat EagerZeroedThick  -Confirm:$false # >$null 2>&1
# let things settle 
Start-Sleep 2
Get-HardDisk -VM $CurrentHwVmName | ForEach-Object {
$HardDisk=$_
if ($HardDisk.Name -ne "Hard disk 1")
{ 
$ProgressTextBox.text=""
$ProgressTextBox.text= $CurrentHwVmName+" '"+$HardDisk.Name+"' size is "+$HardDisk.CapacityGB+" GB"
# a delay so the message can be seen
Start-sleep 5
$ProgressTextBox.text=""
$ProgressTextBox.text= $CurrentHwVmName+" '"+$HardDisk.Name+"' size is Provisioned as: "+$HardDisk.StorageFormat
# a delay so the message can be seen
Start-sleep 5
}
}
$ProgressTextBox.text=""
$ProgressTextBox.text= "The 2 disks Added to VM $CurrentHwVmName"
# a delay so the message can be seen
Start-sleep 5
}
$Thisvm = Get-VM -Name $CurrentHwVmName
if ($Thisvm.PowerState -eq "PoweredOn")
{
# if we can try to shut it down otherwise power it off
if($Thisvm.Guest.State -eq "Running")
{
    $ProgressTextBox.text=  "Shutdown Virtual Machine $CurrentHwVmName"
    # a delay so the message can be seen
    Start-sleep 1
    Shutdown-VMGuest -VM $Thisvm -Confirm:$false >$null 2>&1
}
else
{
    $ProgressTextBox.text=  "Power Off Virtual Machine $CurrentHwVmName"
    # a delay so the message can be seen
    Start-sleep 1
    Stop-VM -VM $Thisvm -Confirm:$false >$null 2>&1
}
}
else
{
$ProgressTextBox.text=  "Virtual Machine $CurrentHwVmName is already Shutdown"
# a delay so the message can be seen
Start-sleep 1
}
$ProgressTextBox.text=  "Close Consoles for VM $CurrentHwVmName"
# a delay so the message can be seen
Start-sleep 1
Get-Process -Name "vmrc"   >$null 2>&1
if ($?) {Get-Process -Name "vmrc"| where {$_.mainWindowTitle -and $_.mainWindowTitle -like "$($CurrentHwVmName)*"}| Stop-Process   >$null 2>&1}
# let things settle 
Start-Sleep 1
Disconnect-VIServer -Server $CurrentH1 -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null


# now the vCenter Stuff

# Connect to vc to add licences
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
$vCenter = Connect-VIServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass # >$null 2>&1
$vcKey=""
$vSKey=""
$vcKey=$vCenterLic.text;
$vSKey=$vSphereLic.text;
if ($vcKey -eq "")
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="No Text typed in so Ignore vCenter License"
 # a delay so the message can be seen
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Try to add vCenter License key  ($vcKey)"
 # a delay so the message can be seen
 Start-sleep 5
 $LM = get-view($vCenter.ExtensionData.content.LicenseManager)
 $LM.AddLicense($vcKey,$null)
}
if ($vsKey -eq "")
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="No Text typed in so Ignore vSphere License"
 # a delay so the message can be seen
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Try to add vSphere License ($vSKey)"
 # a delay so the message can be seen
 Start-sleep 5
 $LM = get-view($vCenter.ExtensionData.content.LicenseManager)
 $LM.AddLicense($vsKey,$null)
}

$licMgr = Get-View licensemanager
$TheLicences = $licMgr.Licenses
ForEach ($ThisLic in $TheLicences)
{
 if ($ThisLic.EditionKey -ne "eval")
 {
  #$ThisLic"
  if ($ThisLic.EditionKey -eq "vc.standard.instance")
  {
   $ProgressTextBox.text=""
   $ProgressTextBox.text="vCenter Standard Licence added is $($ThisLic.LicenseKey)"
   # a delay so the message can be seen
   Start-sleep 2
   if ($vcKey -eq $ThisLic.LicenseKey) {$CorrectVCLic=$true}
  }
  if ($ThisLic.EditionKey -eq "esx.enterprisePlus.cpuPackageCoreLimited")
  {
   $ProgressTextBox.text=""
   $ProgressTextBox.text="vShere Enterprise Plus Licence added is $($ThisLic.LicenseKey)"
   # a delay so the message can be seen
   Start-sleep 2
   if ($vsKey -eq $ThisLic.LicenseKey) {$CorrectVsLic=$true}
  }
 }
}
#Disconnect From Host
Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null

if ($CorrectVCLic -and $CorrectVsLic)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text=  "Both the Licenses have been added to $CurrentVC"
 # a delay so the message can be seen
 Start-sleep 5
 $CarryOn=$true
}
else
{
 $ProgressTextBox.text=""
 if ($CorrectVCLic)
 {$ProgressTextBox.text="Only the vCenter License has been added"}
 elseif ($CorrectVsLic)
 {$ProgressTextBox.text="Only the vSphere License has been added"}
 else
 {$ProgressTextBox.text=  "Neither of the Licenses have been added to $CurrentVC"}
 # a delay so the message can be seen
 Start-sleep 5
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Red"
 if ($CorrectVCLic)
 {$ProgressTextBox.text="Stopping before Lab 6 Task 3.. need the correct vSphere License Key"}
 elseif ($CorrectVsLic)
 {$ProgressTextBox.text="Stopping before Lab 6 Task 3.. need the correct vCenter License Key"}
 else
 {$ProgressTextBox.text=  "Stopping before Lab 6 Task 3.. need correct vCenter and vSphere License Keys"}
 $CarryOn=$false
}

if ($CarryOn)
{
 # Connect to vc to assign vc license
 Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
 $vCenter = Connect-VIServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass # >$null 2>&1
 $vcKey=""
 $vSKey=""
 $ThisLic=""
 $CorrectVCLic=$false
 $licMgr = Get-View licensemanager
 $TheLicences = $licMgr.Licenses
 ForEach ($ThisLic in $TheLicences)
 {
  if ($ThisLic.EditionKey -ne "eval")
  {
   if ($ThisLic.EditionKey -eq "esx.enterprisePlus.cpuPackageCoreLimited")
   {
    $ProgressTextBox.text=""
    $ProgressTextBox.text="vShere Enterprise Plus Licence added is $($ThisLic.LicenseKey)"
    # a delay so the message can be seen
    Start-sleep 5
    $CurVSLic=$ThisLic.LicenseKey
    $CorrectVsLic=$true
   }
   elseif ($ThisLic.EditionKey -eq "vc.standard.instance")
   {
    $ProgressTextBox.text=""
    $ProgressTextBox.text="vCenter Standard Licence added is $($ThisLic.LicenseKey)"
    # a delay so the message can be seen
    Start-sleep 2
    $vcKey=$ThisLic.LicenseKey
    $CorrectVCLic=$true
   }
  }
 }
 if ($vcKey -eq "")
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="The vCenter License Has not been added"
  # a delay so the message can be seen
  Start-sleep 1
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Assign vCenter License $vcKey"
  # a delay so the message can be seen
  Start-sleep 5
  $LM = get-view($vCenter.ExtensionData.content.LicenseManager)
  $LAM = get-view($LM.licenseAssignmentManager)
  $LAM.UpdateAssignedLicense($vCenter.InstanceUuid,$vcKey,$Null)
 }
 $CorrectVCLic=$false
 $ThisLic=""
 $licMgr = Get-View licensemanager
 $licAMgr = get-view($LM.licenseAssignmentManager)
 $TheLicences  = $licAMgr.QueryAssignedLicenses($gloabl.defaultviservers.instanceuuid) | Group-Object -Property EntityId, EntityDisplayName, Scope
 ForEach ($ThisLic in $TheLicences)
 {
  $CurrLic=$ThisLic.Group[0]
  $licenseObj = [PSCustomObject]@{
         EntityDisplayName = $CurrLic.EntityDisplayName
         Name = $CurrLic.AssignedLicense.Name
         LicenseKey = $CurrLic.AssignedLicense.LicenseKey
         EditionKey = $CurrLic.AssignedLicense.EditionKey
         ProductName = $CurrLic.AssignedLicense.Properties | Where-Object {$_.Key -eq 'ProductName'} | Select-Object -ExpandProperty Value
         ProductVersion = $CurrLic.AssignedLicense.Properties | Where-Object {$_.Key -eq 'ProductVersion'} | Select-Object -ExpandProperty Value
         EntityId = $CurrLic.EntityId
         Scope = $CurrLic.Scope
         }
  if (($licenseObj.EntityDisplayName -eq $CurrentVC) -and ($licenseObj.LicenseKey -eq $vcKey)){$CorrectVCLic=$true}
 }
  #Disconnect From Host
 Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
        
 if ($CorrectVCLic)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text=  "The License $vcKey has been Assigned to $CurrentVC"
  # a delay so the message can be seen
  Start-sleep 5
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.BackColor="Red"
  $ProgressTextBox.text= "Stopping before Lab 6 Task 2... the vCenter License has not been assigned"
  $CarryOn=$false
 }
}

# by now the licences should be sorted, but check first
if ($CarryOn)
{
 # Connect to vc
 Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
 $vCenter = Connect-VIServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass # >$null 2>&1
 # The Datacenter needs to exist so let's check if it's there
 # >$null 2>&1 hides the output
 # $? true if it's found and false if it's not
 Get-Datacenter -Name $CurrentDataCenter >$null 2>&1
 if ($?)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="$CurrentDataCenter already exists"
  Start-sleep 5
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Datacenter $CurrentDataCenter has been already added to $CurrentVC"
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Create Datacenter $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
  New-Datacenter -Name $CurrentDataCenter -Location Datacenters -WarningAction SilentlyContinue
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Datacenter $CurrentDataCenter has been added to $CurrentVC"
 }
 # let things settle
 start-sleep 1
 # add H1
 Get-Datacenter -Name $CurrentDataCenter| Get-VMHost -Name $CurrentH1 >$null 2>&1
 if ($?)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text=  "$CurrentH1 has already been added to Datacenter $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
  Set-VMHost -VMHost $CurrentH1 -LicenseKey $CurVSLic >$null 2>&1
 }
 else
 {
  Add-VMHost -Name $CurrentH1 -Location $CurrentDataCenter -User $CurrentH1User -Password $CurrentH1Pass -Force:$true >$null 2>&1
  $ProgressTextBox.text=""
  $ProgressTextBox.text=  "$CurrentH1 has been added to Datacenter $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
  Set-VMHost -VMHost $CurrentH1 -LicenseKey $CurVSLic >$null 2>&1
 }
 # add H2
 Get-Datacenter -Name $CurrentDataCenter| Get-VMHost -Name $CurrentH2 >$null 2>&1
 if ($?)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text=  "$CurrentH2 has already been added to Datacenter $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
  Set-VMHost -VMHost $CurrentH2 -LicenseKey $CurVSLic >$null 2>&1
 }
 else
 {
  Add-VMHost -Name $CurrentH2 -Location $CurrentDataCenter -User $CurrentH2User -Password $CurrentH2Pass -Force:$true >$null 2>&1
  $ProgressTextBox.text=""
  $ProgressTextBox.text=  "$CurrentH2 has been added to Datacenter $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
  Set-VMHost -VMHost $CurrentH2 -LicenseKey $CurVSLic >$null 2>&1
 }
 # Licence pre-existing hosts while we're here
 Set-VMHost -VMHost $CurrentH4 -LicenseKey $CurVSLic >$null 2>&1
 Set-VMHost -VMHost $CurrentH5 -LicenseKey $CurVSLic >$null 2>&1
 Set-VMHost -VMHost $CurrentH6 -LicenseKey $CurVSLic >$null 2>&1
 Start-sleep 5
 # make sure all hosts are in the connected state
 $MyHosts= Get-VMHost | where { $_.ConnectionState -eq "Disconnected" }
 foreach ($ThisHost in $MyHosts) {Set-VMHost -VMHost $ThisHost -State Connected}
 $ProgressTextBox.text=""
 $ProgressTextBox.text=  "Both Hosts Have been added to Datacenter $CurrentDataCenter"
 Start-sleep 5
 $ProgressTextBox.text=""
 $ProgressTextBox.text=  "Set Ntp Server to $CurrentNTP on $CurrentH1"
 # a delay so the message can be seen
 Start-sleep 5 
 # Set Ntp Source
 Add-VmHostNtpServer -VMHost $CurrentH1 -NtpServer $CurrentNTP  >$null 2>&1
 Start-Sleep 1
 $ProgressTextBox.text=""
 $ProgressTextBox.text=  "Set Ntp to start on $CurrentH1 boot"
 # a delay so the message can be seen
 Start-sleep 5 
 # Set NTP start on Boot
 Get-VmHostService -VMHost $CurrentH1 | Where-Object {$_.key -eq "ntpd"} |Set-VMHostService -Policy On
 Start-sleep 1
 $ProgressTextBox.text=""
 $ProgressTextBox.text=  "Start Ntp Service on $CurrentH1"
 # a delay so the message can be seen
 Start-sleep 5 
 # Start NTP Service
 Get-VmHostService -VMHost $CurrentH1 | Where-Object {$_.key -eq "ntpd"} | Restart-VMHostService -Confirm:$false
 Start-Sleep 1
 $ProgressTextBox.text=""
 $ProgressTextBox.text=  "Set Ntp Server to $CurrentNTP on $CurrentH2"
 # a delay so the message can be seen
 Start-sleep 5 
 # Set Ntp Source
 Add-VmHostNtpServer -VMHost $CurrentH2 -NtpServer $CurrentNTP  >$null 2>&1
 Start-Sleep 1
 $ProgressTextBox.text=""
 $ProgressTextBox.text=  "Set Ntp to start on $CurrentH2 boot"
 # a delay so the message can be seen
 Start-sleep 5 
 # Set NTP start on Boot
 Get-VmHostService -VMHost $CurrentH2 | Where-Object {$_.key -eq "ntpd"} |Set-VMHostService -Policy On
 Start-sleep 1
 $ProgressTextBox.text=""
 $ProgressTextBox.text=  "Start Ntp Service on $CurrentH2"
 # a delay so the message can be seen
 Start-sleep 5 
 # Start NTP Service
 Get-VmHostService -VMHost $CurrentH2 | Where-Object {$_.key -eq "ntpd"} | Restart-VMHostService -Confirm:$false
 Start-Sleep 1
 # is the folder already there
 Get-Folder -Name $CurrentHCFolder  >$null 2>&1
 if ($?)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="$CurrentHCFolder already exists below $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
 }
 else
 {
  #seems to default to "Host and Clusters" view
  New-Folder -Name $CurrentHCFolder -Location $CurrentDataCenter
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Created Hosts & Cluster Folder $CurrentHCFolder below  $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
 }
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Put $CurrentH1 into folder $CurrentHCFolder"
 # a delay so the message can be seen
 Start-sleep 5
 # move h1
 Move-VMHost -VMHost $CurrentH1 -Destination $CurrentHCFolder -Confirm:$false  >$null 2>&1
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Put $CurrentH2 into folder $CurrentHCFolder"
 # a delay so the message can be seen
 Start-sleep 5
 # move h2
 Move-VMHost -VMHost $CurrentH2 -Destination $CurrentHCFolder -Confirm:$false  >$null 2>&1      
 Start-sleep 1
 # is the folder already there
 Get-Folder -Name $CurrentVTFolder1  >$null 2>&1
 if ($?)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="$CurrentVTFolder1 already exists below $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
 }
 else
 {
  # the get-folder vm is to get the "VMs and Templates View"
  New-Folder -Name $CurrentVTFolder1 -Location (Get-Folder -Name 'vm' -Location (Get-Datacenter -Name "$CurrentDataCenter"))
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Created VMs & Templates Folder $CurrentVTFolder1 below  $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
 }
 # is the folder already there
 Get-Folder -Name $CurrentVTFolder2  >$null 2>&1
 if ($?)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="$CurrentVTFolder2 already exists below $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
 }
 else
 {
  # the get-folder vm is to get the "VMs and Templates View"
  New-Folder -Name $CurrentVTFolder2 -Location (Get-Folder -Name 'vm' -Location (Get-Datacenter -Name "$CurrentDataCenter"))
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Created VMs & Templates Folder $CurrentVTFolder2 below  $CurrentDataCenter"
  # a delay so the message can be seen
  Start-sleep 5
 }
 #one way or another the folders are here now
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Put $CurrVM1 into folder $CurrentVTFolder1"
 # a delay so the message can be seen
 Start-sleep 5
 # move vm1
 Get-VM -Name $CurrVM1 | Move-VM -Destination $CurrentH1 -InventoryLocation  (Get-Folder -Name $CurrentVTFolder1) -Confirm:$false  >$null 2>&1
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Put $CurrVM2 into folder $CurrentVTFolder1"
 # a delay so the message can be seen
 Start-sleep 5
 # move vm3
 Get-VM -Name $CurrVM2 | Move-VM -Destination $CurrentH1 -InventoryLocation  (Get-Folder -Name $CurrentVTFolder1) -Confirm:$false  >$null 2>&1
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Put $CurrVM3 into folder $CurrentVTFolder1"
 # a delay so the message can be seen
 Start-sleep 5
 # move vm1
 Get-VM -Name $CurrVM3 | Move-VM -Destination $CurrentH1 -InventoryLocation  (Get-Folder -Name $CurrentVTFolder1) -Confirm:$false  >$null 2>&1
 start-sleep 1
 Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
 # due to the reboot this will be done while disconnected
$secpasswd = ConvertTo-SecureString $CurrentVCLocPass -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential($CurrentVCLocUser, $secpasswd)
$SessionID = New-SSHSession -AcceptKey  -ComputerName $CurrentVC -Credential $Credentials #Connect Over SSH
$CurrentVCCommand1 = "/opt/likewise/bin/domainjoin-cli query"
Invoke-SSHCommand -OutVariable result -Index $sessionid.sessionid -Command $CurrentVCCommand1   >$null 2>&1 # Invoke Command Over SSH
$outit=$result.output
if ($outit[1] -ne "Domain = VCLASS.LOCAL")
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="$CurrentVC Not in Domain $CurrentADDomain yet"
 # a delay so the message can be seen
 Start-sleep 5
 $CurrentVCCommand1 = "/opt/likewise/bin/domainjoin-cli  join $CurrentADDomain $CurrentADDomainU $CurrentADDomainP"
 Invoke-SSHCommand -OutVariable result -Index $sessionid.sessionid -Command $CurrentVCCommand1   >$null 2>&1 # Invoke Command Over SSH
 $outit=$result.output
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Domain Add = "+$outit[3]
 # a delay so the message can be seen
 Start-sleep 5
 $CurrentVCCommand1 = "reboot"
 Invoke-SSHCommand -OutVariable result -Index $sessionid.sessionid -Command $CurrentVCCommand1   >$null 2>&1 # Invoke Command Over SSH
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Please wait for the reboot of $CurrentVC"
 # a delay so the message can be seen
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="$CurrentVC is Already in Domain $CurrentADDomain"
 # a delay so the message can be seen
 Start-sleep 5
}
 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Green"
 $ProgressTextBox.text= "Ready For Lab 9 Task 1"
}