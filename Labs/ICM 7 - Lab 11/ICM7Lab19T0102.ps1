# MODULE Create vSwitch2 using vmnic2 and a port group Called vMotion
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

# Connect to host 1
$current_host="sa-esxi-01.vclass.local"
$Current_Kernel_address = "172.20.12.51"
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Scope Session -Confirm:$false

Connect-VIServer -Server $current_host -User root -Password "VMware1!"
# create vSwitch2 and Connect it to vmnic2
Get-VMHost $current_host | New-VirtualSwitch -Name "vSwitch2" -Nic vmnic2
Start-Sleep 1
# Get Context of Newly Created Switch
$Current_switch = Get-VirtualSwitch -VMHost $current_host -Name "vSwitch2"
#Create the Port Group Called vMotion
$current_Port_Group = New-VirtualPortGroup -VirtualSwitch $Current_switch -Name "vMotion"
New-VMHostNetworkAdapter -VMHost $Current_Host -PortGroup "vMotion" -VirtualSwitch $Current_Switch -IP $Current_Kernel_address -SubnetMask 255.255.255.0 -VMotionEnabled $true

Start-Sleep 1
# Disconnect From Host
Disconnect-VIServer -Server $current_host -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
		
# Connect to host 2
$current_host="sa-esxi-02.vclass.local"
$Current_Kernel_address = "172.20.12.52"
Connect-VIServer -Server $current_host -User root -Password "VMware1!"
# create vSwitch2 and Connect it to vmnic2
Get-VMHost $current_host | New-VirtualSwitch -Name "vSwitch2" -Nic vmnic2
Start-Sleep 1
# Get Context of Newly Created Switch
$Current_switch = Get-VirtualSwitch -VMHost $current_host -Name "vSwitch2"
#Create the Port Group Called vMotion
$current_Port_Group = New-VirtualPortGroup -VirtualSwitch $Current_switch -Name "vMotion"
New-VMHostNetworkAdapter -VMHost $Current_Host -PortGroup "vMotion" -VirtualSwitch $Current_Switch -IP $Current_Kernel_address -SubnetMask 255.255.255.0 -VMotionEnabled $true

Start-Sleep 1
# Disconnect From Host
Disconnect-VIServer -Server $current_host -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
		
# End of Module