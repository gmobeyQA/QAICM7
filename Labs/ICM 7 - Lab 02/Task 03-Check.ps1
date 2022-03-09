﻿# MODULE TO Check Local and ssh shells
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Local and Ssh Shells)"
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
$CurrentDomain="vclass.local"
$CurrentDUser="administrator"
$CurrentDPass="VMware1!"
$TheSvc="TSM","TSM-SSH"
# Connect to Host
$FinalMsg=""
$bothworked=$true
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
Connect-VIServer -Server $CurrentH1 -User $CurrentH1User -Password $CurrentH1Pass  >$null 2>&1
foreach ($CurrSvc in $TheSvc)
{
        $AllServices = Get-VMHostService
        $ThisService = $AllServices | Where-Object {$_.Key -eq $CurrSvc}
        if ($ThisService.running -eq $true)
        {
            $ProgressTextBox.text=""
            $ProgressTextBox.text="$CurrSvc is Started on Host $CurrentH1"
            $FinalMsg=$FinalMsg+"$CurrSvc is Started "
            # a delay so the message can be seen
            Start-sleep 5
        }
        else
        {
            $ProgressTextBox.text=""
            $ProgressTextBox.text="$CurrSvc is Stopped on Host $CurrentH1"
            $FinalMsg=$FinalMsg+"$CurrSvc is Stopped "
            $bothworked=$false
            # a delay so the message can be seen
            Start-sleep 5
        }
}

# let things settle 
Start-Sleep 1
Disconnect-VIServer -Server $CurrentH1 -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null 
$FinalMsg=$FinalMsg -replace 'TSM-SSH',', Ssh Shell'  
$FinalMsg=$FinalMsg -replace 'TSM','Local Shell'
if ($bothworked)
{
$ProgressTextBox.BackColor = "Green"
            $ProgressTextBox.text=""
$ProgressTextBox.text=$FinalMsg+"On $CurrentH1"
}
else
{
$ProgressTextBox.BackColor = "Red"
            $ProgressTextBox.text=""
$ProgressTextBox.text=$FinalMsg+"On $CurrentH1 Redo Lab 2 Task 3"
}
# End of Module