# MODULE TO Get Ready for Lab 23 Task 1
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Get Ready for Lab 21 Task 1)"
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
$NewStdvSwitch="vSwitch1"
$NewStdvSwNic="vmnic3"
$NewStdvSwVMPG="Production"
$OldStdvSwitch="vSwitch0"
$OldStdSwVMPG="VM Network"
$IpStNic="vmnic3"
$IpStVMPG="IP Storage"
$IpStKpAddr = "172.20.10.62"
$IpStKpMask = "255.255.255.0"
$IpStiSCSItgt="172.20.10.15" 
$Curr_FirstLun=2
$Current_firstDatatoreName = "VMFS-2"
$Current_firstDatatoreName2 = "Shared-VMFS"
$Current_firstDatatoreSizeGB=8
$Curr_secondLun=6
$Current_SecondDatatoreName = "VMFS-3"
$Curr_ThirdLun=5
$Current_ThirdDatatoreName = "iSCSI-Datastore" 
$Current_nfsDatastorename= "NFS-Datastore"
$Current_nfsPath = "/NFS-Data"
$Current_nfsHost = "172.20.10.10"
$VM2bTemplate = "Photon-Template"
$Cust_Spec = "Photon-CustomSpec"
$DnsSvr = "172.20.10.10"
$CstSpecDom="vclass.local"
$SharedDatastoreName="iSCSI-Datastore"
$DeplTemplate="Photon-Template"
$VM2Deploy1= "Photon-11"
$VM2Deploy2= "Photon-12"
$ContLib="VM Library"
$ContLibDS="vsanDatastore"
$Template2Clone="Photon-Template"
$ContLibTempl="Photon-LibTemplate"
$VM2Deploy3= "Photon-13"
$VMoStdvSwitch="vSwitch2"
$VMoNic="vmnic2"
$VMoVMPG="vMotion"
$VMoKpAddr = "172.20.12.51"
$VMoKpAddr2 = "172.20.12.52"
$VMoKpMask = "255.255.255.0"
$OriginalDatastoreName="ICM-Datastore"

Get-Item -Path Function:\Get-VMHostiSCSIBinding  >$null 2>&1
if ($?)
{Remove-Item Function:\Get-VMHostiSCSIBinding}
function Get-VMHostiSCSIBinding {
<#
 .SYNOPSIS
 Function to get the iSCSI Binding of a VMHost.

 .DESCRIPTION
 Function to get the iSCSI Binding of a VMHost.

 .PARAMETER VMHost
 VMHost to get iSCSI Binding for.

.PARAMETER HBA
 HBA to use for iSCSI

.INPUTS
 String.
 System.Management.Automation.PSObject.

.OUTPUTS
 VMware.VimAutomation.ViCore.Impl.V1.EsxCli.EsxCliObjectImpl.

.EXAMPLE
 PS> Get-VMHostiSCSIBinding -VMHost ESXi01 -HBA "vmhba32"

 .EXAMPLE
 PS> Get-VMHost ESXi01,ESXi02 | Get-VMHostiSCSIBinding -HBA "vmhba32"
#>
[CmdletBinding()][OutputType('VMware.VimAutomation.ViCore.Impl.V1.EsxCli.EsxCliObjectImpl')]

Param
 (

[parameter(Mandatory=$true,ValueFromPipeline=$true)]
 [ValidateNotNullOrEmpty()]
 [PSObject[]]$VMHost,
 [parameter(Mandatory=$true,ValueFromPipeline=$false)]
 [ValidateNotNullOrEmpty()]
 [String]$HBA
 )

begin {

 }

 process {

 foreach ($ESXiHost in $VMHost){

try {

if ($ESXiHost.GetType().Name -eq "string"){

 try {
 $ESXiHost = Get-VMHost $ESXiHost -ErrorAction Stop
 }
 catch [Exception]{
 Write-Warning "VMHost $ESXiHost does not exist"
 }
 }

 elseif ($ESXiHost -isnot [VMware.VimAutomation.ViCore.Impl.V1.Inventory.VMHostImpl]){
 Write-Warning "You did not pass a string or a VMHost object"
 Return
 }

 # --- Check for the iSCSI HBA
 try {

$iSCSIHBA = $ESXiHost | Get-VMHostHba -Device $HBA -Type iSCSI
 }
 catch [Exception]{

throw "Specified iSCSI HBA does not exist"
 }

# --- Set the iSCSI Binding via ESXCli
 Write-Verbose "Getting iSCSI Binding for $ESXiHost"
 $ESXCli = Get-EsxCli -VMHost $ESXiHost

$ESXCli.iscsi.networkportal.list($HBA)
 }
 catch [Exception]{

 throw "Unable to get iSCSI Binding config"
 }
 }
 }
 end {

 }
}

Get-Item -Path Function:\Get-ContentLibrary  >$null 2>&1
if ($?)
{Remove-Item Function:\Get-ContentLibrary}
Function Get-ContentLibrary {
<#
    .NOTES
    ===========================================================================
    Created by:    William Lam
    Organization:  VMware
    Blog:          www.virtuallyghetto.com
    Twitter:       @lamw
    ===========================================================================
    .DESCRIPTION
        This function lists all available vSphere Content Libaries
    .PARAMETER LibraryName
        The name of a vSphere Content Library
    .EXAMPLE
        Get-ContentLibrary
    .EXAMPLE
        Get-ContentLibrary -LibraryName Test
#>
    param(
        [Parameter(Mandatory=$false)][String]$LibraryName
    )

    $contentLibraryService = Get-CisService com.vmware.content.library
    $LibraryIDs = $contentLibraryService.list()

    $results = @()
    foreach($libraryID in $LibraryIDs) {
        $library = $contentLibraryService.get($libraryID)

        # Use vCenter REST API to retrieve name of Datastore that is backing the Content Library
        $datastoreService = Get-CisService com.vmware.vcenter.datastore
        $datastore = $datastoreService.get($library.storage_backings.datastore_id)

        if($library.publish_info.published) {
            $published = $library.publish_info.published
            $publishedURL = $library.publish_info.publish_url
            $externalReplication = $library.publish_info.persist_json_enabled
        } else {
            $published = $library.publish_info.published
            $publishedURL = "N/A"
            $externalReplication = "N/A"
        }

        if($library.subscription_info) {
            $subscribeURL = $library.subscription_info.subscription_url
            $published = "N/A"
        } else {
            $subscribeURL = "N/A"
        }

        if(!$LibraryName) {
            $libraryResult = [pscustomobject] @{
                Id = $library.Id;
                Name = $library.Name;
                Type = $library.Type;
                Description = $library.Description;
                Datastore = $datastore.name;
                Published = $published;
                PublishedURL = $publishedURL;
                JSONPersistence = $externalReplication;
                SubscribedURL = $subscribeURL;
                CreationTime = $library.Creation_Time;
            }
            $results+=$libraryResult
        } else {
            if($LibraryName -eq $library.name) {
                $libraryResult = [pscustomobject] @{
                    Name = $library.Name;
                    Id = $library.Id;
                    Type = $library.Type;
                    Description = $library.Description;
                    Datastore = $datastore.name;
                    Published = $published;
                    PublishedURL = $publishedURL;
                    JSONPersistence = $externalReplication;
                    SubscribedURL = $subscribeURL;
                    CreationTime = $library.Creation_Time;
                }
                $results+=$libraryResult
            }
        }
    }
    $results
}

Get-Item -Path Function:\Get-ContentLibraryItems  >$null 2>&1
if ($?)
{Remove-Item Function:\Get-ContentLibraryItems}
Function Get-ContentLibraryItems {
<#
    .NOTES
    ===========================================================================
    Created by:    William Lam
    Organization:  VMware
    Blog:          www.virtuallyghetto.com
    Twitter:       @lamw
    ===========================================================================
    .DESCRIPTION
        This function lists all items within a given vSphere Content Library
    .PARAMETER LibraryName
        The name of a vSphere Content Library
    .PARAMETER LibraryItemName
        The name of a vSphere Content Library Item
    .EXAMPLE
        Get-ContentLibraryItems -LibraryName Test
    .EXAMPLE
        Get-ContentLibraryItems -LibraryName Test -LibraryItemName TinyPhotonVM
#>
    param(
        [Parameter(Mandatory=$true)][String]$LibraryName,
        [Parameter(Mandatory=$false)][String]$LibraryItemName
    )

    $contentLibraryService = Get-CisService com.vmware.content.library
    $LibraryIDs = $contentLibraryService.list()

    $results = @()
    foreach($libraryID in $LibraryIDs) {
        $library = $contentLibraryService.get($libraryId)
        if($library.name -eq $LibraryName) {
            $contentLibraryItemService = Get-CisService com.vmware.content.library.item
            $itemIds = $contentLibraryItemService.list($libraryID)

            foreach($itemId in $itemIds) {
                $item = $contentLibraryItemService.get($itemId)

                if(!$LibraryItemName) {
                    $itemResult = [pscustomobject] @{
                        Name = $item.name;
                        Id = $item.id;
                        Description = $item.description;
                        Size = $item.size
                        Type = $item.type;
                        Version = $item.version;
                        MetadataVersion = $item.metadata_version;
                        ContentVersion = $item.content_version;
                    }
                    $results+=$itemResult
                } else {
                    if($LibraryItemName -eq $item.name) {
                        $itemResult = [pscustomobject] @{
                            Name = $item.name;
                            Id = $item.id;
                            Description = $item.description;
                            Size = $item.size
                            Type = $item.type;
                            Version = $item.version;
                            MetadataVersion = $item.metadata_version;
                            ContentVersion = $item.content_version;
                        }
                        $results+=$itemResult
                    }
                }
            }
        }
    }
    $results
}

Get-Item -Path Function:\Get-ContentLibraryItemFiles  >$null 2>&1
if ($?)
{Remove-Item Function:\Get-ContentLibraryItemFiles}
Function Get-ContentLibraryItemFiles {
<#
    .NOTES
    ===========================================================================
    Created by:    William Lam
    Organization:  VMware
    Blog:          www.virtuallyghetto.com
    Twitter:       @lamw
    ===========================================================================
    .DESCRIPTION
        This function lists all item files within a given vSphere Content Library
    .PARAMETER LibraryName
        The name of a vSphere Content Library
    .PARAMETER LibraryItemName
        The name of a vSphere Content Library Item
    .EXAMPLE
        Get-ContentLibraryItemFiles -LibraryName Test
    .EXAMPLE
        Get-ContentLibraryItemFiles -LibraryName Test -LibraryItemName TinyPhotonVM
#>
    param(
        [Parameter(Mandatory=$true)][String]$LibraryName,
        [Parameter(Mandatory=$false)][String]$LibraryItemName
    )

    $contentLibraryService = Get-CisService com.vmware.content.library
    $libraryIDs = $contentLibraryService.list()

    $results = @()
    foreach($libraryID in $libraryIDs) {
        $library = $contentLibraryService.get($libraryId)
        if($library.name -eq $LibraryName) {
            $contentLibraryItemService = Get-CisService com.vmware.content.library.item
            $itemIds = $contentLibraryItemService.list($libraryID)
            $DatastoreID = $library.storage_backings.datastore_id.Value
            $Datastore = get-datastore -id "Datastore-$DatastoreID"

            foreach($itemId in $itemIds) {
                $itemName = ($contentLibraryItemService.get($itemId)).name
                $contentLibraryItemFileSerice = Get-CisService com.vmware.content.library.item.file
                $files = $contentLibraryItemFileSerice.list($itemId)
                $contentLibraryItemStorageService = Get-CisService com.vmware.content.library.item.storage

                foreach($file in $files) {
                    if($contentLibraryItemStorageService.get($itemId, $($file.name)).storage_backing.type -eq "DATASTORE"){
                        $filepath = $contentLibraryItemStorageService.get($itemId, $($file.name)).storage_uris.segments -notmatch '(^/$|^vmfs$*|^volumes$*|vsan:.*)' -join ''
                        $fullfilepath = "[$($datastore.name)] $filepath"
                    }
                    else{
                        $fullfilepath = "UNKNOWN"
                    }

                    if(!$LibraryItemName) {
                        $fileResult = [pscustomobject] @{
                            Name = $file.name;
                            Version = $file.version;
                            Size = $file.size;
                            Stored = $file.cached;
                            Path = $fullfilepath;
                        }
                        $results+=$fileResult
                    } else {
                        if($itemName -eq $LibraryItemName) {
                            $fileResult = [pscustomobject] @{
                                Name = $file.name;
                                Version = $file.version;
                                Size = $file.size;
                                Stored = $file.cached;
                                Path = $fullfilepath;
                            }
                            $results+=$fileResult
                        }
                    }
                }
            }
        }
    }
    $results
}

Get-Item -Path Function:\Set-ContentLibrary  >$null 2>&1
if ($?)
{Remove-Item Function:\Set-ContentLibrary}
Function Set-ContentLibrary {
<#
    .NOTES
    ===========================================================================
    Created by:    William Lam
    Organization:  VMware
    Blog:          www.virtuallyghetto.com
    Twitter:       @lamw
    ===========================================================================
    .DESCRIPTION
        This function updates the JSON Persistence property for a given Content Library
    .PARAMETER LibraryName
        The name of a vSphere Content Library
    .EXAMPLE
        Set-ContentLibraryItems -LibraryName Test -JSONPersistenceEnabled
    .EXAMPLE
        Set-ContentLibraryItems -LibraryName Test -JSONPersistenceDisabled
#>
    param(
        [Parameter(Mandatory=$true)][String]$LibraryName,
        [Parameter(Mandatory=$false)][Switch]$JSONPersistenceEnabled,
        [Parameter(Mandatory=$false)][Switch]$JSONPersistenceDisabled
    )

    $contentLibraryService = Get-CisService com.vmware.content.library
    $LibraryIDs = $contentLibraryService.list()

    $found = $false
    foreach($libraryID in $LibraryIDs) {
        $library = $contentLibraryService.get($libraryId)
        if($library.name -eq $LibraryName) {
            $found = $true
            break
        }
    }

    if($found) {
        $localLibraryService = Get-CisService -Name "com.vmware.content.local_library"

        if($JSONPersistenceEnabled) {
            $jsonPersist = $true
        } else {
            $jsonPersist = $false
        }

        $updateSpec = $localLibraryService.Help.update.update_spec.Create()
        $updateSpec.type = $library.type
        $updateSpec.publish_info.authentication_method = $library.publish_info.authentication_method
        $updateSpec.publish_info.persist_json_enabled = $jsonPersist
        Write-Host "Updating JSON Persistence configuration setting for $LibraryName  ..."
        $localLibraryService.update($library.id,$updateSpec)
    } else {
        Write-Host "Unable to find Content Library $Libraryname"
    }
}

Get-Item -Path Function:\New-LocalContentLibrary  >$null 2>&1
if ($?)
{Remove-Item Function:\New-LocalContentLibrary}
Function New-LocalContentLibrary {
<#
    .NOTES
    ===========================================================================
    Created by:    William Lam
    Organization:  VMware
    Blog:          www.virtuallyghetto.com
    Twitter:       @lamw
    ===========================================================================
    .DESCRIPTION
        This function creates a new Subscriber Content Library from a JSON Persisted
        Content Library that has been externally replicated
    .PARAMETER LibraryName
        The name of the new vSphere Content Library
    .PARAMETER DatastoreName
        The name of the vSphere Datastore to store the Content Library
    .PARAMETER Publish
        Whther or not to publish the Content Library, this is required for JSON Peristence
    .PARAMETER JSONPersistence
        Whether or not to enable JSON Persistence which enables external replication of Content Library
    .EXAMPLE
        New-LocalContentLibrary -LibraryName Foo -DatastoreName iSCSI-01 -Publish $true
    .EXAMPLE
        New-LocalContentLibrary -LibraryName Foo -DatastoreName iSCSI-01 -Publish $true -JSONPersistence $true
#>
    param(
        [Parameter(Mandatory=$true)][String]$LibraryName,
        [Parameter(Mandatory=$true)][String]$DatastoreName,
        [Parameter(Mandatory=$false)][Boolean]$Publish=$true,
        [Parameter(Mandatory=$false)][Boolean]$JSONPersistence=$false
    )

    $datastore = Get-Datastore -Name $DatastoreName

    if($datastore) {
        $datastoreId = $datastore.ExtensionData.MoRef.Value
        $localLibraryService = Get-CisService -Name "com.vmware.content.local_library"

        $StorageSpec = [pscustomobject] @{
                        datastore_id = $datastoreId;
                        type         = "DATASTORE";
        }

        $UniqueChangeId = [guid]::NewGuid().tostring()

        $createSpec = $localLibraryService.Help.create.create_spec.Create()
        $createSpec.name = $LibraryName
        $addResults = $createSpec.storage_backings.Add($StorageSpec)
        $createSpec.publish_info.authentication_method = "NONE"
        $createSpec.publish_info.persist_json_enabled = $JSONPersistence
        $createSpec.publish_info.published = $Publish
        $createSpec.type = "LOCAL"
        #Write-Host "Creating new Local Content Library called $LibraryName ..."
        $library = $localLibraryService.create($UniqueChangeId,$createSpec)
    }
}

Get-Item -Path Function:\Remove-LocalContentLibrary  >$null 2>&1
if ($?)
{Remove-Item Function:\Remove-LocalContentLibrary}
Function Remove-LocalContentLibrary {
<#
    .NOTES
    ===========================================================================
    Created by:    William Lam
    Organization:  VMware
    Blog:          www.virtuallyghetto.com
    Twitter:       @lamw
    ===========================================================================
    .DESCRIPTION
        This function deletes a Local Content Library
    .PARAMETER LibraryName
        The name of the new vSphere Content Library to delete
    .EXAMPLE
        Remove-LocalContentLibrary -LibraryName Bar
#>
    param(
        [Parameter(Mandatory=$true)][String]$LibraryName
    )

    $contentLibraryService = Get-CisService com.vmware.content.library
    $LibraryIDs = $contentLibraryService.list()

    $found = $false
    foreach($libraryID in $LibraryIDs) {
        $library = $contentLibraryService.get($libraryId)
        if($library.name -eq $LibraryName) {
            $found = $true
            break
        }
    }

    if($found) {
        $localLibraryService = Get-CisService -Name "com.vmware.content.local_library"

        Write-Host "Deleting Local Content Library $LibraryName ..."
        $localLibraryService.delete($library.id)
    } else {
        Write-Host "Unable to find Content Library $LibraryName"
    }
}

Get-Item -Path Function:\Copy-ContentLibrary  >$null 2>&1
if ($?)
{Remove-Item Function:\Copy-ContentLibrary}
Function Copy-ContentLibrary {
<#
    .NOTES
    ===========================================================================
    Created by:    William Lam
    Organization:  VMware
    Blog:          www.virtuallyghetto.com
    Twitter:       @lamw
    ===========================================================================
    .DESCRIPTION
        This function copies all library items from one Content Library to another
    .PARAMETER SourceLibraryName
        The name of the source Content Library to copy from
    .PARAMETER DestinationLibraryName
        The name of the desintation Content Library to copy to
    .PARAMETER DeleteSourceFile
        Whther or not to delete library item from the source Content Library after copy
    .EXAMPLE
        Copy-ContentLibrary -SourceLibraryName Foo -DestinationLibraryName Bar
    .EXAMPLE
        Copy-ContentLibrary -SourceLibraryName Foo -DestinationLibraryName Bar -DeleteSourceFile $true
#>
    param(
        [Parameter(Mandatory=$true)][String]$SourceLibraryName,
        [Parameter(Mandatory=$true)][String]$DestinationLibraryName,
        [Parameter(Mandatory=$false)][Boolean]$DeleteSourceFile=$false
    )

    $sourceLibraryId = (Get-ContentLibrary -LibraryName $SourceLibraryName).Id
    if($sourceLibraryId -eq $null) {
        Write-Host -ForegroundColor red "Unable to find Source Content Library named $SourceLibraryName"
        exit
    }
    $destinationLibraryId = (Get-ContentLibrary -LibraryName $DestinationLibraryName).Id
    if($destinationLibraryId -eq $null) {
        Write-Host -ForegroundColor Red "Unable to find Destination Content Library named $DestinationLibraryName"
        break
    }

    $sourceItemFiles = Get-ContentLibraryItems -LibraryName $SourceLibraryName
    if($sourceItemFiles -eq $null) {
        Write-Host -ForegroundColor red "Unable to retrieve Content Library Items from $SourceLibraryName"
        break
    }

    $contentLibraryItemService = Get-CisService com.vmware.content.library.item

    foreach ($sourceItemFile in  $sourceItemFiles) {
        # Check to see if file already exists in destination Content Library
        $result = Get-ContentLibraryItems -LibraryName $DestinationLibraryName -LibraryItemName $sourceItemFile.Name

        if($result -eq $null) {
            # Create CopySpec
            $copySpec = $contentLibraryItemService.Help.copy.destination_create_spec.Create()
            $copySpec.library_id = $destinationLibraryId
            $copySpec.name = $sourceItemFile.Name
            $copySpec.description = $sourceItemFile.Description
            # Create random Unique Copy Id
            $UniqueChangeId = [guid]::NewGuid().tostring()

            # Perform Copy
            try {
                Write-Host -ForegroundColor Cyan "Copying" $sourceItemFile.Name "..."
                $copyResult = $contentLibraryItemService.copy($UniqueChangeId, $sourceItemFile.Id, $copySpec)
            } catch {
                Write-Host -ForegroundColor Red "Failed to copy" $sourceItemFile.Name
                $Error[0]
                break
            }

            # Delete source file if set to true
            if($DeleteSourceFile) {
                try {
                    Write-Host -ForegroundColor Magenta "Deleteing" $sourceItemFile.Name "..."
                    $deleteResult = $contentLibraryItemService.delete($sourceItemFile.Id)
                } catch {
                    Write-Host -ForegroundColor Red "Failed to delete" $sourceItemFile.Name
                    $Error[0]
                    break
                }
            }
        } else {
            Write-Host -ForegroundColor Yellow "Skipping" $sourceItemFile.Name "already exists"

            # Delete source file if set to true
            if($DeleteSourceFile) {
                try {
                    Write-Host -ForegroundColor Magenta "Deleteing" $sourceItemFile.Name "..."
                    $deleteResult = $contentLibraryItemService.delete($sourceItemFile.Id)
                } catch {
                    Write-Host -ForegroundColor Red "Failed to delete" $sourceItemFile.Name
                    break
                }
            }
        }
    }
}


Get-Item -Path Function:\Add-TemplateToLibrary  >$null 2>&1
if ($?)
{Remove-Item Function:\Add-TemplateToLibrary}
Function Add-TemplateToLibrary {
<#
.NOTES :
--------------------------------------------------------
Created by : Stuart Yerdon
Website : NotesofaScripter.com
--------------------------------------------------------
.DESCRIPTION
This function uploads a VM to the Content library.
.PARAMETER LibraryName
Name of the libray to which item needs to be uploaded.
.PARAMETER VMname
Name of the VM to upload.
.PARAMETER LibItemName
Name of the template after imported to library.
.PARAMETER Description
Description of the imported item.
.EXAMPLE
Add-TemplateToLibrary -LibraryName 'LibraryName' -VMname '2016 STD Template v1.0 VM' -LibItemName '2016 STD Template' -Description 'Uploaded via API calls'
#>
 
 param
 (
 [Parameter(Mandatory=$true)][string]$LibraryName,
 [Parameter(Mandatory=$true)][string]$Templatename,
 [Parameter(Mandatory=$true)][string]$LibItemName,
 [Parameter(Mandatory=$true)][string]$Description
 )
 
 $ContentLibraryService = Get-CisService com.vmware.content.library
 $libaryIDs = $contentLibraryService.list()
 foreach($libraryID in $libaryIDs)
 {
  $library = $contentLibraryService.get($libraryID)
  if($library.name -eq $LibraryName)
  {
   $library_ID = $libraryID
   break
  }
 }
 if(!$library_ID)
 {write-host -ForegroundColor red $LibraryName " -- is not exists.."}
 else
 {
  $ContentLibraryOvfService = Get-CisService com.vmware.vcenter.ovf.library_item
  $UniqueChangeId = [guid]::NewGuid().tostring()
  $createOvfTarget = $ContentLibraryOvfService.Help.create.target.Create()
  $createOvfTarget.library_id = $library_ID
  $createOvfSource = $ContentLibraryOvfService.Help.create.source.Create()
  $createOvfSource.type = ((Get-template $Templatename).ExtensionData.MoRef).Type
  $createOvfSource.id = ((Get-template $Templatename).ExtensionData.MoRef).Value
  $createOvfCreateSpec = $ContentLibraryOvfService.help.create.create_spec.Create()
  $createOvfCreateSpec.name = $LibItemName
  $createOvfCreateSpec.description = $Description
  #$createOvfCreateSpec.flags = ""
  write-host "Creating Library Item -- " $LibItemName
  $libraryTemplateId = $ContentLibraryOvfService.create($UniqueChangeId,$createOvfSource,$createOvfTarget,$createOvfCreateSpec)
 }
}

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
 {$ProgressTextBox.text="Stopping before Lab 6 Task 4.. need the correct vSphere License Key"}
 elseif ($CorrectVsLic)
 {$ProgressTextBox.text="Stopping before Lab 6 Task 4.. need the correct vCenter License Key"}
 else
 {$ProgressTextBox.text=  "Stopping before Lab 6 Task 4.. need correct vCenter and vSphere License Keys"}
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
 #
 # vc's ad join code removed as not needed by labs 11 and later
 #
 # create vSwitch1 and Connect it to vmnic3
 # does it exist already?
 # >$null 2>&1 hides the output
 # $? true if it's found and false if it's not
 Get-VirtualSwitch -VMHost $CurrentH1 -Name $NewStdvSwitch  >$null 2>&1
 if ($?)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="$NewStdvSwitch already exists"
  # a delay so the message can be seen
  Start-sleep 5
  $Current_switch = Get-VirtualSwitch -VMHost $CurrentH1 -Name $NewStdvSwitch
  $thisNic=$Current_switch.Nic
  if ("$thisNic" -eq "")
  {
   $ProgressTextBox.text=""
   $ProgressTextBox.text="Adding $NewStdvSwNic to $NewStdvSwitch"
   # a delay so the message can be seen
   Start-sleep 5
   $ThisVMHostNetworkAdapter = (Get-VMhost $CurrentH1 | Get-VMHostNetworkAdapter -Physical -Name $NewStdvSwNic)
   Get-VirtualSwitch -VMHost $CurrentH1 -Name $NewStdvSwitch| Add-VirtualSwitchPhysicalNetworkAdapter -VMHostPhysicalNic $ThisVMHostNetworkAdapter -Confirm:$false
  }
  elseif ("$thisNic" -eq "$NewStdvSwNic")
  {
   $ProgressTextBox.text=""
   $ProgressTextBox.text="$NewStdvSwNic is already added to $NewStdvSwitch"
   # a delay so the message can be seen
   Start-sleep 5
  }
  else
  {
   $ProgressTextBox.text=""
   $ProgressTextBox.text="$thisNic incorrectly added to $NewStdvSwitch - Removing it"
   # a delay so the message can be seen
   Start-sleep 5
   Get-VMhost $CurrentH1| Get-VMHostNetworkAdapter -Physical -Name $thisNic | Remove-VirtualSwitchPhysicalNetworkAdapter -Confirm:$false
   $ProgressTextBox.text=""
   $ProgressTextBox.text="Adding $NewStdvSwNic to $NewStdvSwitch"
   # a delay so the message can be seen
   Start-sleep 5
   $ThisVMHostNetworkAdapter = (Get-VMhost $CurrentH1 | Get-VMHostNetworkAdapter -Physical -Name $NewStdvSwNic)
   Get-VirtualSwitch -VMHost $CurrentH1 -Name $NewStdvSwitch| Add-VirtualSwitchPhysicalNetworkAdapter -VMHostPhysicalNic $ThisVMHostNetworkAdapter -Confirm:$false
  }
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Creating $NewStdvSwitch on $CurrentH1"
  # a delay so the message can be seen
  Start-sleep 5
  Get-VMHost $CurrentH1 | New-VirtualSwitch -Name $NewStdvSwitch -Nic $NewStdvSwNic   >$null 2>&1
  Start-Sleep 1
 }
 # at this point The switch exists
 #now add the Virtual Machine Port Group
 Get-VirtualSwitch -VMHost $CurrentH1 -Name $NewStdvSwitch| Get-VirtualPortGroup -Name $NewStdvSwVMPG   >$null 2>&1
 if ($?)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="$NewStdvSwVMPG is already added to $NewStdvSwitch"
  # a delay so the message can be seen
  Start-sleep 5
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Adding $NewStdvSwVMPG to $NewStdvSwitch"
  # a delay so the message can be seen
  Start-sleep 5
  # Get Context of Newly Created Switch
  $Current_switch = Get-VirtualSwitch -VMHost $CurrentH1 -Name $NewStdvSwitch
  #Create the Port Group Called Production
  $current_Port_Group = New-VirtualPortGroup -VirtualSwitch $Current_switch -Name $NewStdvSwVMPG
  Start-Sleep 1
 }
 # create vSwitch and Connect it to vmnic3
 # does it exist already?
 # >$null 2>&1 hides the output
 # $? true if it's found and false if it's not
 Get-VirtualSwitch -VMHost $CurrentH2 -Name $NewStdvSwitch  >$null 2>&1
 if ($?)
 {
 $ProgressTextBox.text=""
  $ProgressTextBox.text="$NewStdvSwitch already exists"
  # a delay so the message can be seen
  Start-sleep 5
  $Current_switch = Get-VirtualSwitch -VMHost $CurrentH2 -Name $NewStdvSwitch
  $thisNic=$Current_switch.Nic
  if ("$thisNic" -eq "")
  {
   $ProgressTextBox.text="Adding $NewStdvSwNic to $NewStdvSwitch"
   # a delay so the message can be seen
   Start-sleep 5
   $ThisVMHostNetworkAdapter = (Get-VMhost $CurrentH2 | Get-VMHostNetworkAdapter -Physical -Name $NewStdvSwNic)
   Get-VirtualSwitch -VMHost $CurrentH2 -Name $NewStdvSwitch| Add-VirtualSwitchPhysicalNetworkAdapter -VMHostPhysicalNic $ThisVMHostNetworkAdapter -Confirm:$false
  }
  elseif ("$thisNic" -eq "$NewStdvSwNic")
  {
   $ProgressTextBox.text=""
   $ProgressTextBox.text="$NewStdvSwNic is already added to $NewStdvSwitch"
   # a delay so the message can be seen
   Start-sleep 5
  }
  else
  {
   $ProgressTextBox.text=""
   $ProgressTextBox.text="$thisNic incorrectly added to $NewStdvSwitch - Removing it"
   # a delay so the message can be seen
   Start-sleep 5
   Get-VMhost $CurrentH2| Get-VMHostNetworkAdapter -Physical -Name $thisNic | Remove-VirtualSwitchPhysicalNetworkAdapter -Confirm:$false
   $ProgressTextBox.text=""
   $ProgressTextBox.text="Adding $NewStdvSwNic to $NewStdvSwitch"
   # a delay so the message can be seen
   Start-sleep 5
   $ThisVMHostNetworkAdapter = (Get-VMhost $CurrentH2 | Get-VMHostNetworkAdapter -Physical -Name $NewStdvSwNic)
   Get-VirtualSwitch -VMHost $CurrentH2 -Name $NewStdvSwitch| Add-VirtualSwitchPhysicalNetworkAdapter -VMHostPhysicalNic $ThisVMHostNetworkAdapter -Confirm:$false
  }
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Creating $NewStdvSwitch on $CurrentH2"
  # a delay so the message can be seen
  Start-sleep 5
  Get-VMHost $CurrentH2 | New-VirtualSwitch -Name $NewStdvSwitch -Nic $NewStdvSwNic   >$null 2>&1
  Start-Sleep 1
 }
 # at this point The switch exists
 #now add the Virtual Machine Port Group
 Get-VirtualSwitch -VMHost $CurrentH2 -Name $NewStdvSwitch| Get-VirtualPortGroup -Name $NewStdvSwVMPG   >$null 2>&1
 if ($?)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="$NewStdvSwVMPG is already added to $NewStdvSwitch"
  # a delay so the message can be seen
  Start-sleep 5
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Adding $NewStdvSwVMPG to $NewStdvSwitch"
  # a delay so the message can be seen
  Start-sleep 5
  # Get Context of Newly Created Switch
  $Current_switch = Get-VirtualSwitch -VMHost $CurrentH2 -Name $NewStdvSwitch
  #Create the Port Group Called Production
  $current_Port_Group = New-VirtualPortGroup -VirtualSwitch $Current_switch -Name $NewStdvSwVMPG
  Start-Sleep 1
 }
 # Get Context of the Created Switch
 $Current_switch = Get-VirtualSwitch -VMHost $CurrentH1 -Name $NewStdvSwitch
 # does the Virtual Machine Portgroup exist?
 Get-VirtualSwitch -VMHost $CurrentH1 -Name $NewStdvSwitch| Get-VirtualPortGroup -Name $NewStdvSwVMPG   >$null 2>&1
 if ($?)
 {
  # Get Context of the VMPG
  $current_Port_Group = Get-VirtualPortGroup -VirtualSwitch $NewStdvSwitch -Name $NewStdvSwVMPG
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Moving VMs to $NewStdvSwVMPG on $NewStdvSwitch"
  # a delay so the message can be seen
  Start-sleep 5
  Get-VMHost $CurrentH1| Get-VM -Name $CurrVM1 |Get-NetworkAdapter |Where {$_.NetworkName -eq $OldStdSwVMPG } |Set-NetworkAdapter -NetworkName $NewStdvSwVMPG -Confirm:$false
  Get-VMHost $CurrentH1| Get-VM -Name $CurrVM2 |Get-NetworkAdapter |Where {$_.NetworkName -eq $OldStdSwVMPG } |Set-NetworkAdapter -NetworkName $NewStdvSwVMPG -Confirm:$false
  Start-Sleep 1
  Start-VM -VM $CurrVM1 -Confirm:$false >$null 2>&1
  Start-VM -VM $CurrVM2 -Confirm:$false >$null 2>&1
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "VMs moved to $NewStdvSwVMPG on $NewStdvSwitch"
 }
 start-sleep 1
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
$Current_Host_Context = Get-VMHost $CurrentH2
#Enable iSCSI
$hostStore=Get-VMHostStorage -VMHost $CurrentH2
if ($hostStore.SoftwareIScsiEnabled)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="iSCSI is already enabled on $CurrentH2"
 # a delay so the message can be seen
 Start-Sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Enabling iSCSI on $CurrentH2"
 Get-VMHostStorage -VMHost $Current_Host_Context | Set-VMHostStorage -SoftwareIScsiEnabled $true
 # a delay so the message can be seen
 Start-Sleep 5	
} 
#Get Software iSCSI adapter HBA number and put it into an array
$HBA = Get-VMHostHba -VMHost $CurrentH2 -Type iSCSI | %{$_.Device}
#Set your VMKernel numbers, Use ESXCLI to create the iSCSI Port binding in the iSCSI Software Adapter,
$vmk1number = 'vmk1'
$esxcli = Get-EsxCli -VMhost $CurrentH2
$thisBinding=Get-VMHostiSCSIBinding -VMhost $CurrentH2 -HBA $HBA
$ThisAdapter=$thisBinding.Adapter
if ("$ThisAdapter" -eq "")
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Setting iSCSI Port Binding"
 $Esxcli.iscsi.networkportal.add($HBA, $Null, $vmk1number)
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="iSCSI Port Binding already set"
}
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
Start-sleep 2
Get-VMHostStorage -VMHost $CurrentH2 -RescanAllHba -RescanVmfs
Start-sleep 2	 

#has lab 13 task 4 already happened
Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_firstDatatoreName2 >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Lab 13 task 4 already done... skipping tasks"
 start-sleep 5
}
else
{
Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_firstDatatoreName >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Datastore $Current_firstDatatoreName already Created"
 # a delay so the message can be seen
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Creating Datastore $Current_firstDatatoreName"
 $VMH1View = Get-VMHost -Name $CurrentH1 | Get-View
 $H1LunsByCanonicalName = Get-VMHost $CurrentH1 | Get-SCSILun
 $H1LunsByKey = $VMH1View.Config.StorageDevice.ScsiTopology | 
		ForEach {$_.Adapter} | where {$_.Adapter -eq "key-vim.host.InternetScsiHba-vmhba65"} | ForEach {$_.Target} | ForEach {$_.Lun}
 $tmpldH1=$VMH1View.Config.StorageDevice.ScsiTopology | ForEach {$_.Adapter} | where {$_.Adapter -eq "key-vim.host.InternetScsiHba-vmhba65"} | ForEach {$_.Target} | ForEach {$_.Lun}|where {$_.Lun -eq $Curr_FirstLun}
 $tmpldH1[0]
 $FirstLunDisk=$tmpldH1[0]
 $FirstLunsKey=$FirstLunDisk.Key.Replace("ScsiTopology.Lun", "ScsiDisk")
 Get-ScsiLun -VMHost $CurrentH1 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $FirstLunsKey}| select CanonicalName,key
 $firstscsilun = Get-ScsiLun -VMHost $CurrentH1 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $FirstLunsKey}

 $H1View = Get-View -ViewType HostSystem -Filter @{'Name'=$CurrentH1}
 $hdSys = Get-View -Id $H1View.ConfigManager.DatastoreSystem
 $disk = $hdSys.QueryAvailableDisksForVmfs($null) | where{$_.CanonicalName -eq $firstscsilun.CanonicalName}
 $opt = $hdSys.QueryVmfsDatastoreCreateOptions($disk.DevicePath,$null)
 $sectorTotal = $Current_firstDatatoreSizeGB * 1GB / 512
 $FirstLunSpec = New-Object VMware.Vim.VmfsDatastoreCreateSpec
 $FirstLunSpec.DiskUuid = $disk.Uuid
 $FirstLunSpec.Partition = $opt[0].Spec.Partition
 $FirstLunSpec.Partition.Partition[0].EndSector = $FirstLunSpec.Partition.Partition[0].StartSector + $sectorTotal
 $FirstLunSpec.Partition.TotalSectors = $sectorTotal
 $FirstLunSpec.Vmfs = New-Object VMware.Vim.HostVmfsSpec
 $FirstLunSpec.Vmfs.VolumeName = $Current_firstDatatoreName
 $ThisExtent = New-Object VMware.Vim.HostScsiDiskPartition
 $ThisExtent.DiskName = $firstscsilun.CanonicalName
 $ThisExtent.Partition = $opt[0].Info.Layout.Partition[0].Partition
 $FirstLunSpec.Vmfs.Extent = $ThisExtent
 $FirstLunSpec.vmfs.MajorVersion = $opt[0].Spec.Vmfs.MajorVersion
 $hdSys.CreateVmfsDatastore($FirstLunSpec)

 #New-Datastore -VMHost $CurrentH1 -Name $Current_firstDatatoreName -Path $firstscsilun.CanonicalName -Vmfs -FileSystemVersion 6
 # a delay so the message can be seen
 Start-sleep 5
}

Get-VMHost -Name $CurrentH2 | Get-Datastore -Name $Current_SecondDatatoreName >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Datastore $Current_SecondDatatoreName already Created"
 # a delay so the message can be seen
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Creating Datastore $Current_SecondDatatoreName"
 $VMH2View = Get-VMHost -Name $CurrentH2 | Get-View
 $H2LunsByCanonicalName = Get-VMHost $CurrentH2 | Get-SCSILun
 $tmpldH2=$VMH2View.Config.StorageDevice.ScsiTopology | ForEach {$_.Adapter} | where {$_.Adapter -eq "key-vim.host.InternetScsiHba-vmhba65"} | ForEach {$_.Target} | ForEach {$_.Lun}|where {$_.Lun -eq $Curr_SecondLun}
 $SecondLunDisk=$tmpldH2[0]
 $SecondLunsKey=$SecondLunDisk.Key.Replace("ScsiTopology.Lun", "ScsiDisk")
 Get-ScsiLun -VMHost $CurrentH2 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $SecondLunsKey}| select CanonicalName,key
 $Secondscsilun = Get-ScsiLun -VMHost $CurrentH2 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $SecondLunsKey}	 
 New-Datastore -VMHost $CurrentH2 -Name $Current_SecondDatatoreName -Path $Secondscsilun.CanonicalName -Vmfs -FileSystemVersion 6
 # a delay so the message can be seen
 Start-sleep 5
}
# let things settle
sleep 1


Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_firstDatatoreName >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Datastore $Current_firstDatatoreName has been Created"
 # a delay so the message can be seen
 Start-sleep 5
 $thisDatastore=Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_firstDatatoreName |Select Name,CapacityGB,
    @{N='DateTime';E={Get-Date}},
    @{N='CanonicalName';E={$_.ExtensionData.Info.Vmfs.Extent[0].DiskName}},
    @{N='LUN';E={
        $esx = Get-View -Id $_.ExtensionData.Host[0].Key -Property Name
        $dev = $_.ExtensionData.Info.Vmfs.Extent[0].DiskName
        $esxcli = Get-EsxCli -VMHost $esx.Name -V2
        $esxcli.storage.nmp.path.list.Invoke(@{'device'=$dev}).RuntimeName.Split(':')[-1].TrimStart('L')}}
 if ($thisDatastore.LUN -eq $Curr_FirstLun)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Datastore $Current_firstDatatoreName Created with the correct Lun"
  # a delay so the message can be seen
  Start-sleep 5
  if ($thisDatastore.CapacityGB -gt $Current_firstDatatoreSizeGB)
  {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Datastore $Current_firstDatatoreName is Expanded"
  # a delay so the message can be seen
  Start-sleep 5
  }
  else
  {
   $ProgressTextBox.text=""
   $ProgressTextBox.text="Expand Datastore $Current_firstDatatoreName"
   $Thisdatastore = get-datastore $Current_firstDatatoreName
   $ThisEsxi = Get-View -Id ($Thisdatastore.ExtensionData.Host |Select-Object -last 1 | Select -ExpandProperty Key)
   $datastoreSystem = Get-View -Id $ThisEsxi.ConfigManager.DatastoreSystem
   $expandOptions = $datastoreSystem.QueryVmfsDatastoreExpandOptions($Thisdatastore.ExtensionData.MoRef)
   $datastoreSystem.ExpandVmfsDatastore($Thisdatastore.ExtensionData.MoRef,$expandOptions.spec)
   # a delay so the message can be seen
   Start-sleep 5
  }
 }
}
  
 Get-VMHost -Name $CurrentH2 | Get-Datastore -Name $Current_SecondDatatoreName >$null 2>&1
 if ($?)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Remove Datastore $Current_SecondDatatoreName"
  # a delay so the message can be seen
  Get-VMHost -Name $CurrentH2 | Get-Datastore -Name $Current_SecondDatatoreName|Remove-Datastore -VMHost $CurrentH2 -confirm:$false
  Start-sleep 5
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Datastore $Current_SecondDatatoreName already removed"
  # a delay so the message can be seen
  Start-sleep 5
 }
 # let things settle
 sleep 1

    # very time sensitive lots of delays needed
    $ProgressTextBox.text=""
    $ProgressTextBox.text="Extend $Current_firstDatatoreName with Lun $Curr_secondLun"
    #rename it first to save time
    Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_firstDatatoreName2  >$null 2>&1
    if ($?)
    {
     $ProgressTextBox.text=""
     $ProgressTextBox.text="Extend $Current_firstDatatoreName already Renamed to $Current_firstDatatoreName2"
    }
    else
    {
     Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_firstDatatoreName | Set-Datastore -Name $Current_firstDatatoreName2
     start-sleep 2
    }
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
  if ($thisDatastore.LUN2 -eq $Curr_secondLun)
  {
   $ProgressTextBox.text=""
   $ProgressTextBox.text="Datastore $Current_firstDatatoreName already Extended"
   # a delay so the message can be seen
   Start-sleep 5
  }
  else
  {
    # it's easier to recreate the second lun to get it's spec
    $VMH1View = Get-VMHost -Name $CurrentH1 | Get-View
    $H1LunsByCanonicalName = Get-VMHost $CurrentH1 | Get-SCSILun
    $tmpldH1=$VMH1View.Config.StorageDevice.ScsiTopology | ForEach {$_.Adapter} | where {$_.Adapter -eq "key-vim.host.InternetScsiHba-vmhba65"} | ForEach {$_.Target} | ForEach {$_.Lun}|where {$_.Lun -eq $Curr_SecondLun}
    $SecondLunDisk=$tmpldH1[0]
    $SecondLunsKey=$SecondLunDisk.Key.Replace("ScsiTopology.Lun", "ScsiDisk")
    Get-ScsiLun -VMHost $CurrentH1 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $SecondLunsKey}| select CanonicalName,key
    $Secondscsilun = Get-ScsiLun -VMHost $CurrentH1 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $SecondLunsKey}	 
    New-Datastore -VMHost $CurrentH1 -Name $Current_SecondDatatoreName -Path $Secondscsilun.CanonicalName -Vmfs -FileSystemVersion 6
    # a delay To give it time to create
    Start-sleep 20
    $ThisHost = Get-VMHost $CurrentH1
    $ds = get-Datastore -name $Current_SecondDatatoreName -VMhost $ThisHost | get-View 
    $storSystem = Get-View $VMH1View.ConfigManager.StorageSystem
    $partInfo = $storSystem.RetrieveDiskPartitionInfo("/vmfs/devices/disks/" + $ds.info.vmfs.extent[0].DiskName)
    $spec = new-Object VMware.Vim.VmfsDatastoreExtendSpec 
    $spec.Extent = $ds.info.vmfs.extent 
    $spec.DiskUuid = ($VMH1View.Config.StorageDevice.ScsiLun | where {$_.DevicePath -like ("*" + $ds.Info.Vmfs.Extent[0].DiskName)}).Uuid
    $spec.Partition = $partInfo[0].Spec
    # let the system settle
    start-sleep 5
    # Destroy datastore
    Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_SecondDatatoreName|Remove-Datastore -VMHost $CurrentH1 -confirm:$false 
    start-Sleep 20
    # Add disk extent to datastore
    # refresh the variables
    $VMH1View = Get-VMHost -Name $CurrentH1 | Get-View
    $ThisHost = Get-VMHost $CurrentH1
    $dsToBeExtended = get-Datastore -name $Current_firstDatatoreName2 -VMhost $ThisHost | get-View 
    $dsSystem = get-View $VMH1View.configManager.DatastoreSystem
    $dsSystem.extendVmfsDatastore($dsToBeExtended.MoRef, $spec)
   $ProgressTextBox.text=""
   $ProgressTextBox.text="Datastore $Current_firstDatatoreName Extended"
   # a delay so the message can be seen
   Start-sleep 5
    }
}

Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_ThirdDatatoreName >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Datastore $Current_ThirdDatatoreName already Created"
 # a delay so the message can be seen
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Creating Datastore $Current_ThirdDatatoreName"
 $VMH1View = Get-VMHost -Name $CurrentH1 | Get-View
 $H1LunsByCanonicalName = Get-VMHost $CurrentH1 | Get-SCSILun
 $H1LunsByKey = $VMH1View.Config.StorageDevice.ScsiTopology | 
		ForEach {$_.Adapter} | where {$_.Adapter -eq "key-vim.host.InternetScsiHba-vmhba65"} | ForEach {$_.Target} | ForEach {$_.Lun}
 $tmpldH1=$VMH1View.Config.StorageDevice.ScsiTopology | ForEach {$_.Adapter} | where {$_.Adapter -eq "key-vim.host.InternetScsiHba-vmhba65"} | ForEach {$_.Target} | ForEach {$_.Lun}|where {$_.Lun -eq $Curr_ThirdLun}
 $tmpldH1[0]
 $ThirdLunDisk=$tmpldH1[0]
 $ThirdLunsKey=$ThirdLunDisk.Key.Replace("ScsiTopology.Lun", "ScsiDisk")
 Get-ScsiLun -VMHost $CurrentH1 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $ThirdLunsKey}| select CanonicalName,key
 $Thirdscsilun = Get-ScsiLun -VMHost $CurrentH1 -LunType disk | where {$_.Vendor -ne "VMware"}|where {$_.Key -like    $ThirdLunsKey}
 New-Datastore -VMHost $CurrentH1 -Name $Current_ThirdDatatoreName -Path $Thirdscsilun.CanonicalName -Vmfs -FileSystemVersion 6
 # a delay so the message can be seen
 Start-sleep 5
}

# check both hosts
Get-VMHost -Name $CurrentH1 | Get-Datastore -Name $Current_nfsDatastorename >$null 2>&1
$nfsH1=$?
Get-VMHost -Name $CurrentH2 | Get-Datastore -Name $Current_nfsDatastorename >$null 2>&1
$nfsH2=$?
Get-Datastore -Name $Current_nfsDatastorename >$null 2>&1
if ($nfsH1 -and $nfsH2)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Datastore $Current_nfsDatastorename already Created"
 # a delay so the message can be seen
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Creating datastore $Current_nfsDatastorename"
 # a delay so the message can be seen
 # no idea why rebooting the 2012 nfsserver fixes the nfs mount timeouts or why doing the new-datastore a 2nd time works but it does
 Restart-Computer -ComputerName "dc.vclass.local" -Force
 start-sleep 180
 Get-Datacenter -Name $CurrentDataCenter | Get-VMHost | New-Datastore -Nfs -FileSystemVersion '4.1' -Name $Current_nfsDatastorename -Path $Current_nfsPath -NfsHost $Current_nfsHost  >$null 2>&1
 start-sleep 20
 Get-Datacenter -Name $CurrentDataCenter | Get-VMHost | New-Datastore -Nfs -FileSystemVersion '4.1' -Name $Current_nfsDatastorename -Path $Current_nfsPath -NfsHost $Current_nfsHost  >$null 2>&1
 Start-sleep 15
}
sleep 1
$ProgressTextBox.text=""
$ProgressTextBox.text="Change $VM2bTemplate VM to Template and move to folder Lab Templates"
Get-Template -Name $VM2bTemplate >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="$VM2bTemplate VM has already been turned into a Template"
 # is it in the correct folder
 Get-Folder -Name $CurrentVTFolder2|Get-Template -Name $VM2bTemplate  >$null 2>&1
 if ($?)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="The Template is already in the folder $CurrentVTFolder2"
 }
}
else
{
 $thisVM=Get-VM -Name $VM2bTemplate
 if ($thisVM.PowerState -ne "PoweredOff")
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Powering Down $VM2bTemplate"
  # if the command works
  Shutdown-VMGuest -VM $VM2bTemplate -Confirm:$false >$null 2>&1
  if ($?){Start-Sleep 30}
  else
  {
   Stop-VM -VM $VM2bTemplate -Confirm:$false >$null 2>&1
   Start-Sleep 20
  }
 }
 Get-VM -Name $VM2bTemplate | Move-VM -Destination $CurrentH1 -InventoryLocation  (Get-Folder -Name $CurrentVTFolder2) -Confirm:$false  >$null 2>&1
 Start-Sleep 5
 Set-VM -VM $VM2bTemplate -ToTemplate -Confirm:$false
 Start-Sleep 1
}

Get-OSCustomizationSpec -Name $Cust_Spec >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Custom Spec $Cust_Spec already Created"
 # a delay so the message can be seen
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Creating Custom Spec $Cust_Spec"
 New-OSCustomizationSpec -Name $Cust_Spec -OSType Linux -Domain $CstSpecDom -DnsSuffix $CstSpecDom -DnsServer $DnsSvr
 # a delay so the message can be seen
 Start-sleep 5
}

$ThisVMFolder=Get-Folder | where {$_.Name -like 'lab*vms'}
$ProgressTextBox.text=""
$ProgressTextBox.text= "Create the 2 VMs"
start-sleep 5
Get-VM -Name $VM2Deploy1 >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "$VM2Deploy1 already Exists"
 start-sleep 5
 $crVM1=$false
}
else
{
 $crVM1=$true
 # First Deploy
 $task01=New-VM -Name $VM2Deploy1 -Template $DeplTemplate -VMHost $CurrentH1 -Datastore $SharedDatastoreName -OSCustomizationSpec $Cust_Spec -Location ($ThisVMFolder) -RunAsync
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "Deploying $VM2Deploy1"
 start-sleep 5
}
# allow them to overlap
Get-VM -Name $VM2Deploy2 >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "$VM2Deploy2 already Exists"
 start-sleep 5
 $crVM2=$false
}
else
{
 $crVM2=$true
 # First Deploy
 #Second Deploy
 $task02=New-VM -Name $VM2Deploy2 -Template $DeplTemplate -VMHost $CurrentH2 -Datastore $SharedDatastoreName -OSCustomizationSpec $Cust_Spec -Location ($ThisVMFolder) -RunAsync
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "Deploying $VM2Deploy2"
 start-sleep 5
}
if ($crVM1)
{
 while($task01.ExtensionData.Info.State -eq "running"){
  sleep 1
  $task01.ExtensionData.UpdateViewData('Info.State')
 }
 # Only start them once deployed
}
#one way or another thy're here
$Thisvm = Get-VM -Name $VM2Deploy1
if ($Thisvm.PowerState -ne "PoweredOn")
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "Boot $VM2Deploy1"
 # a delay so the message can be seen
 Start-sleep 1
 $Thisvm | Start-VM -Confirm:$false  >$null 2>&1
 # let things settle 
 Start-Sleep 2
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text=  "VM $VM2Deploy1 is already Booted"
 # a delay so the message can be seen
 Start-sleep 5
}
while($task02.ExtensionData.Info.State -eq "running"){
  sleep 1
  $task02.ExtensionData.UpdateViewData('Info.State')
}
$Thisvm = Get-VM -Name $VM2Deploy2
if ($Thisvm.PowerState -ne "PoweredOn")
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "Boot $VM2Deploy2"
 # a delay so the message can be seen
 Start-sleep 1
 $Thisvm | Start-VM -Confirm:$false  >$null 2>&1
 # let things settle 
 Start-Sleep 2
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text=  "VM $VM2Deploy2 is already Booted"
 # a delay so the message can be seen
 Start-sleep 5
}

# content library stuff need connection to cisServer
Connect-CisServer -Server $CurrentVC -User $CurrentVCUser -Password $CurrentVCPass
$thisLib=Get-ContentLibrary -LibraryName $ContLib
if ($Thislib.Name -eq $ContLib)
{
$ProgressTextBox.text=""
$ProgressTextBox.text="Content Library ($ContLib) already exists"
}
else
{
 ProgressTextBox.text=""
 $ProgressTextBox.text="Creating Content Library ($ContLib)"
 New-LocalContentLibrary -LibraryName $ContLib -DatastoreName $ContLibDS -Publish $false -JSONPersistence $false
}
 $thisItem=Get-ContentLibraryItems -LibraryName $ContLib -LibraryItemName $ContLibTempl
 $ThisItemName=$thisItem.Name
 if ($ThisItemName -eq $ContLibTempl)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Content Library Template ($ContLibTempl) already exists"
  start-sleep 3
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Adding Content Library Template ($ContLibTempl)"
  Add-TemplateToLibrary -LibraryName $ContLib -Templatename $Template2Clone -LibItemName $ContLibTempl -Description "Lab 17 Task 3"
  start-sleep 3
 }
Disconnect-CisServer -Server $CurrentVC  -Confirm:$false
# not needed by other scripts

$Thisvm = Get-VM -Name $CurrVM3
 if ($Thisvm.PowerState -ne "PoweredOn")
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Booting VM $CurrVM3"
  $Thisvm | Start-VM -Confirm:$false  >$null 2>&1
  # a delay so the message can be seen
  Start-Sleep 5
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "VM $CurrVM3 is already Booted"
  start-sleep 5
 }
 if ($Thisvm.MemoryMB -eq "4500")
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "VM $CurrVM3 memory is already set to 4500MB"
  start-sleep 5
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "setting VM $CurrVM3 memory to 4500MB"
  Get-VM  $CurrVM3 | Set-VM -MemoryMB 4500 -Confirm:$false
  # a delay so the message can be seen
  start-sleep 5
 }
 $thisDisk=Get-HardDisk -VM $CurrVM3
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "VM $CurrVM3 HD Current Size is "+$thisDisk.CapacityGB+"GB"
 start-sleep 5
 if ($thisDisk.CapacityGB -eq "27")
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "VM $CurrVM3 HD is already set to 27GB"
  start-sleep 5
 }
 else
 {
  $ProgressTextBox.text="Set VM $CurrVM3 HD to 27GB"
  Get-HardDisk -VM  $CurrVM3 | Set-HardDisk -CapacityGB 27 -Confirm:$false
  # a delay so the message can be seen
  start-sleep 5
 }
if ($Thisvm.PowerState -eq "PoweredOn")
{
# if we can try to shut it down otherwise power it off
if($Thisvm.Guest.State -eq "Running")
{
    $ProgressTextBox.text=  "Shutdown Virtual Machine $CurrVM3"
    # a delay so the message can be seen
    Start-sleep 1
    Shutdown-VMGuest -VM $Thisvm -Confirm:$false >$null 2>&1
}
else
{
    $ProgressTextBox.text=  "Power Off Virtual Machine $CurrVM3"
    # a delay so the message can be seen
    Start-sleep 1
    Stop-VM -VM $Thisvm -Confirm:$false >$null 2>&1
}
}
else
{
$ProgressTextBox.text=  "Virtual Machine $CurrVM3 is already Shutdown"
# a delay so the message can be seen
Start-sleep 1
}

# create vSwitch and Connect it to vmnic
# does it exist already?
# >$null 2>&1 hides the output
# $? true if it's found and false if it's not
Get-VirtualSwitch -VMHost $CurrentH1 -Name $VMoStdvSwitch  >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="$VMoStdvSwitch already exists"
 # a delay so the message can be seen
 Start-sleep 5
 $Current_switch = Get-VirtualSwitch -VMHost $CurrentH1 -Name $VMoStdvSwitch
 $thisNic=$Current_switch.Nic
 if ("$thisNic" -eq "")
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Adding $VMoNic to $VMoStdvSwitch"
  # a delay so the message can be seen
  Start-sleep 5
  $ThisVMHostNetworkAdapter = (Get-VMhost $CurrentH1 | Get-VMHostNetworkAdapter -Physical -Name $VMoNic)
  Get-VirtualSwitch -VMHost $CurrentH1 -Name $VMoStdvSwitch| Add-VirtualSwitchPhysicalNetworkAdapter -VMHostPhysicalNic $ThisVMHostNetworkAdapter -Confirm:$false
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="$VMoNic is already added to $VMoStdvSwitch"
  # a delay so the message can be seen
  Start-sleep 5
 }
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Creating $VMoStdvSwitch on $CurrentH1"
 # a delay so the message can be seen
 Start-sleep 5
 Get-VMHost $CurrentH1 | New-VirtualSwitch -Name $VMoStdvSwitch -Nic $VMoNic   >$null 2>&1
 Start-Sleep 1
}
# at this point The switch exists
#now add the Virtual Machine Port Group
Get-VirtualSwitch -VMHost $CurrentH1 -Name $VMoStdvSwitch| Get-VirtualPortGroup -Name $VMoVMPG   >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="$VMoVMPG is already added to $VMoStdvSwitch"
 # a delay so the message can be seen
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Adding $VMoVMPG to $VMoStdvSwitch"
 # a delay so the message can be seen
 Start-sleep 5
 # Get Context of Newly Created Switch
 $Current_switch = Get-VirtualSwitch -VMHost $CurrentH1 -Name $VMoStdvSwitch
 #Create the Port Group Called Production
 $current_Port_Group = New-VirtualPortGroup -VirtualSwitch $Current_switch -Name $VMoVMPG
 Start-Sleep 1
}
$Current_Switch = Get-VirtualSwitch -VMHost $CurrentH1 -Name $VMoStdvSwitch
# Create the Port Group
Get-VirtualSwitch -VMHost $CurrentH1 -Name $VMoStdvSwitch| Get-VirtualPortGroup -Name $VMoVMPG   >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="$VMoVMPG is already added to $VMoStdvSwitch"
 # a delay so the message can be seen
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Adding $VMoVMPG to $VMoStdvSwitch"
 # a delay so the message can be seen
 Start-sleep 5
 # Get Context of Newly Created Switch
 $Current_switch = Get-VirtualSwitch -VMHost $CurrentH1 -Name $VMoStdvSwitch
 #Create the Port Group Called Production
 $current_Port_Group = New-VirtualPortGroup -VirtualSwitch $Current_switch -Name $VMoVMPG
 Start-Sleep 1
}
# Turn the VMPG Into a Kernel Port
$ProgressTextBox.text=""
$ProgressTextBox.text="Adding the Kernel Port to $VMoVMPG"
# a delay so the message can be seen
Start-sleep 5
Get-VMHostNetworkAdapter -VMHost $CurrentH1 -VMKernel -name 'vmk2'  >$null 2>&1
if ($?)
{
 # Turn the Kernel Port Into a VMPG
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Kernel Port vmk2 already added to $VMoVMPG"
 # a delay so the message can be seen
 Start-sleep 5
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Kernel Port vmk2 IP address and state will be set"
 # make sure it has the correct addres and vMotion is switched on
 Get-VMHost $CurrentH1 | Get-VMHostNetworkAdapter | where { $_.PortGroupName -eq $VMoVMPG } | Set-VMHostNetworkAdapter -IP $VMoKpAddr -SubnetMask $VMoKpMask -VMotionEnabled $true -confirm:$false
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Adding the Kernel Port vmk2 to $VMoVMPG"
 # a delay so the message can be seen
 Start-sleep 5
 New-VMHostNetworkAdapter -VMHost $CurrentH1 -PortGroup $VMoVMPG -VirtualSwitch $Current_Switch -IP $VMoKpAddr -SubnetMask $VMoKpMask -VMotionEnabled $true
 Start-sleep 5
}

# create vSwitch and Connect it to vmnic
# does it exist already?
# >$null 2>&1 hides the output
# $? true if it's found and false if it's not
Get-VirtualSwitch -VMHost $CurrentH2 -Name $VMoStdvSwitch  >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="$VMoStdvSwitch already exists"
 # a delay so the message can be seen
 Start-sleep 5
 $Current_switch = Get-VirtualSwitch -VMHost $CurrentH2 -Name $VMoStdvSwitch
 $thisNic=$Current_switch.Nic
 if ("$thisNic" -eq "")
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="Adding $VMoNic to $VMoStdvSwitch"
  # a delay so the message can be seen
  Start-sleep 5
  $ThisVMHostNetworkAdapter = (Get-VMhost $CurrentH2 | Get-VMHostNetworkAdapter -Physical -Name $VMoNic)
  Get-VMHost $CurrentH1 | Get-VMHostNetworkAdapter | where { $_.PortGroupName -eq $VMoVMPG } | Set-VMHostNetworkAdapter -IP $VMoKpAddr -SubnetMask $VMoKpMask -VMotionEnabled $true -confirm:$false
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text="$VMoNic is already added to $VMoStdvSwitch"
  # a delay so the message can be seen
  Start-sleep 5
 }
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Creating $VMoStdvSwitch on $CurrentH2"
 # a delay so the message can be seen
 Start-sleep 5
 Get-VMHost $CurrentH2 | New-VirtualSwitch -Name $VMoStdvSwitch -Nic $VMoNic   >$null 2>&1
 Start-Sleep 1
}
# at this point The switch exists
#now add the Virtual Machine Port Group
Get-VirtualSwitch -VMHost $CurrentH2 -Name $VMoStdvSwitch| Get-VirtualPortGroup -Name $VMoVMPG   >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="$VMoVMPG is already added to $VMoStdvSwitch"
 # a delay so the message can be seen
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Adding $VMoVMPG to $VMoStdvSwitch"
 # a delay so the message can be seen
 Start-sleep 5
 # Get Context of Newly Created Switch
 $Current_switch = Get-VirtualSwitch -VMHost $CurrentH2 -Name $VMoStdvSwitch
 #Create the Port Group Called Production
 $current_Port_Group = New-VirtualPortGroup -VirtualSwitch $Current_switch -Name $VMoVMPG
 Start-Sleep 1
}
$Current_Switch = Get-VirtualSwitch -VMHost $CurrentH2 -Name $VMoStdvSwitch
# Create the Port Group
Get-VirtualSwitch -VMHost $CurrentH2 -Name $VMoStdvSwitch| Get-VirtualPortGroup -Name $VMoVMPG   >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="$VMoVMPG is already added to $VMoStdvSwitch"
 # a delay so the message can be seen
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Adding $VMoVMPG to $VMoStdvSwitch"
 # a delay so the message can be seen
 Start-sleep 5
 # Get Context of Newly Created Switch
 $Current_switch = Get-VirtualSwitch -VMHost $CurrentH2 -Name $VMoStdvSwitch
 #Create the Port Group Called Production
 $current_Port_Group = New-VirtualPortGroup -VirtualSwitch $Current_switch -Name $VMoVMPG
 Start-Sleep 1
}
# Turn the VMPG Into a Kernel Port
$ProgressTextBox.text=""
$ProgressTextBox.text="Adding the Kernel Port to $VMoVMPG"
# a delay so the message can be seen
Start-sleep 5
Get-VMHostNetworkAdapter -VMHost $CurrentH2 -VMKernel -name 'vmk2'  >$null 2>&1
if ($?)
{
 # Turn the Kernel Port Into a VMPG
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Kernel Port vmk2 already added to $VMoVMPG"
 # a delay so the message can be seen
 Start-sleep 5
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Kernel Port vmk2 IP address and state will be set"
 # make sure it has the correct address and vMotion is switched on
 Get-VMHost $CurrentH2 | Get-VMHostNetworkAdapter | where { $_.PortGroupName -eq $VMoVMPG } | Set-VMHostNetworkAdapter -IP $VMoKpAddr2 -SubnetMask $VMoKpMask -VMotionEnabled $true -confirm:$false
 Start-sleep 5
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Adding the Kernel Port vmk2 to $VMoVMPG"
 # a delay so the message can be seen
 Start-sleep 5
 New-VMHostNetworkAdapter -VMHost $CurrentH2 -PortGroup $VMoVMPG -VirtualSwitch $Current_Switch -IP $VMoKpAddr2 -SubnetMask $VMoKpMask -VMotionEnabled $true
 Start-sleep 5
}

$ProgressTextBox.text=""
$ProgressTextBox.text= "Move the 2 VMs"
start-sleep 5
Get-VM -Name $CurrVM1 >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "$CurrVM1 Exists"
 start-sleep 5
 $thisVM=Get-VM -Name $CurrVM1
 if ($thisVM.VMHost.Name -eq $CurrentH2)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "$CurrVM1 is already on $CurrentH2"
  start-sleep 5
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Move $CurrVM1 to $CurrentH2"
  start-sleep 5
  Move-VM -VM $CurrVM1 -Destination $CurrentH2
 }
 Get-VM -Name $CurrVM2 >$null 2>&1
if ($?)
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "$CurrVM2 Exists"
 start-sleep 5
 $thisVM=Get-VM -Name $CurrVM2
 if ($thisVM.VMHost.Name -eq $CurrentH2)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "$CurrVM2 is already on $CurrentH2"
  start-sleep 5
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Move $CurrVM2 to $CurrentH2"
  start-sleep 5
  Move-VM -VM $CurrVM2 -Destination $CurrentH2
 }
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "$CurrVM2 is Missing"
 start-sleep 5
}
}
else
{
 $ProgressTextBox.text=""
 $ProgressTextBox.text= "$CurrVM1 is Missing"
 start-sleep 5
}

 $thisVM=Get-VM -Name $VM2Deploy1
 if ($thisVM.VMHost.Name -eq $CurrentH2)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "$VM2Deploy1 is already on $CurrentH2"
  start-sleep 5
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Move $VM2Deploy1 to $CurrentH2"
  start-sleep 5
  Move-VM -VM $VM2Deploy1 -Destination $CurrentH2
 }
 $TargetDS=Get-Datastore -Name $SharedDatastoreName #| select *
 $thisVM=Get-VM -Name $VM2Deploy1 #| select *
 if ($thisVM.DatastoreIdList[0] -eq $TargetDS.Id)
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "$VM2Deploy1 is already on $SharedDatastoreName"
  start-sleep 5
 }
 else
 {
  $ProgressTextBox.text=""
  $ProgressTextBox.text= "Move $VM2Deploy1 to $SharedDatastoreName"
  start-sleep 5
  Get-VM -Name $VM2Deploy1| Move-VM -Datastore $SharedDatastoreName
 }

 Disconnect-VIServer -Server $CurrentVC -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null

 $ProgressTextBox.text=""
 $ProgressTextBox.BackColor="Green"
 $ProgressTextBox.text= "Ready For Lab 17 Task 3"
}