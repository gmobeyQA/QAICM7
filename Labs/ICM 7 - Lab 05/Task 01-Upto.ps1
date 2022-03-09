# MODULE TO Get Ready for Lab 5 Task 1
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Get Ready for Lab 5 Task 1)"
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
$CurrentCrVmDatastore="ICM-Datastore"
$ISODatastore = "ICM-Datastore"
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
$CurrCluster="ICM-Compute-01"
$DRSMigRate = 1

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
Get-Process -Name "vmrc" >$null 2>&1
if ($?) {Get-Process -Name "vmrc"| where {$_.mainWindowTitle -and $_.mainWindowTitle -like "$($CurrentTlVmName)*"}| Stop-Process   >$null 2>&1}
# let things settle 
Start-Sleep 1
Disconnect-VIServer -Server $CurrentH1 -Confirm:$false
        $DefaultVIServer = $null
        $DefaultVIServers = $null
$ProgressTextBox.text=""
$ProgressTextBox.BackColor="Green"
$ProgressTextBox.text= "Ready For Lab 5 Task 1"
# End of Module