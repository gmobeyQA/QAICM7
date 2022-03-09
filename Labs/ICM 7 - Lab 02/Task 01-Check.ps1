# MODULE TO Check on AD Authentication on Host
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Check on AD Authentication on Host)"
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
$PrevLabsOk=$false
$ProgressTextBox.text = "First, Check Lab 2 Task 1 succeeded"
# a delay so the message can be seen
Start-sleep 1
# Connect to Host
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
Connect-VIServer -Server $CurrentH1 -User $CurrentH1User -Password $CurrentH1Pass  >$null 2>&1

$CurrAuth=Get-VMHostAuthentication -VMHost $CurrentH1 -Server $CurrentH1
if ($CurrAuth.Domain -notlike "VCLASS.LOCAL")
{
        $ProgressTextBox.BackColor = "Red"
        $ProgressTextBox.text = ""
        $ProgressTextBox.text = "Re-do Lab2 Task1 ... We are not connected to a $CurrentDomain"
}
else
{
        $ProgressTextBox.text = "Good, $CurrentH1 is Authenticating against AD Domain $CurrentDomain"
        $ProgressTextBox.text = ""
        # a delay so the message can be seen
        Start-sleep 5
        $PrevLabsOk=$True
}
# let things settle 
Start-Sleep 1
Disconnect-VIServer -Server $CurrentH1 -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
if ($PrevLabsOk)
{
        $CurrentDUser="esxadmin"
        $ProgressTextBox.text = "Next Check Domain Authentication"
        # a delay so the message can be seen
        Start-sleep 1
        Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false  >$null 2>&1
        Connect-VIServer -Server $CurrentH1 -User $CurrentDUser -Password $CurrentDPass  >$null 2>&1
        if ($?)
        {
                $ProgressTextBox.BackColor = "Green"
                $ProgressTextBox.text = ""
                $ProgressTextBox.text = "esxadmins can Login to host $CurrentH1 "
        }
        else
        {
                $ProgressTextBox.BackColor = "Red"
                $ProgressTextBox.text = ""
                $ProgressTextBox.text = "Redo Lab 2 Task 1... esxadmins cannot login to $CurrentH1 "
        }
        # let things settle
        Start-Sleep 1
        Disconnect-VIServer -Server $CurrentH1 -Confirm:$false
                $DefaultVIServer = $null
                $DefaultVIServers = $null
}
# End of Module