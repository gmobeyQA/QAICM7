# Import namespaces so that types can be referred by
# their mere name (e.g., `Form` rather than `System.Windows.Forms.Form`)
#
using namespace System.Windows.Forms
using namespace System.Drawing
Clear-Host
$pressed_key="no"
$RTFLocation="C:\Materials\PowerShell\Labs"
[array]$LabDropDownArray = Get-ChildItem $RTFLocation\*.lab | Select-Object BaseName
$LabDropDownArray = $LabDropDownArray -replace '@{BaseName=',''
$LabDropDownArray = $LabDropDownArray -replace '}',''
[string]$RTFDatas = ""
[System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")  | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  | Out-Null
function Whatis-LabDropDown
{
	$Choice = $LabDropDown.SelectedItem.ToString()
	if ($Choice.length -lt 1){$this_Lab = "$$$$"}
    else
    {
     $this_Lab = $Choice
     $TaskDropDown.SelectedIndex=-1
     $TaskDropDown.SelectedIndex=-1
	 $groupBoxActions.Enabled=$False
	 $groupBoxActions.Visible=$False
    }
	return , $this_Lab
}
function Whatis-TaskDropDown
{
	$Choice = $TaskDropDown.SelectedItem.ToString()
	if ($Choice.length -lt 1){$this_task = "$$$$"} else {$this_task = "$RTFLocation\$Global:LabPrefix\$Choice"}
	return , $this_task
}
function RadioChoice
{
    $CheckboxOnlyInstructions.Enabled=$RadioButton1.Checked 
    if ($RadioButton1.Checked -eq $true) {$WhichChoice="As_Written"}
    elseif ($RadioButton2.Checked -eq $true) {$WhichChoice="Do_For_Me"}
    elseif ($RadioButton3.Checked -eq $true) {$WhichChoice="Undo_For_Me"}
    elseif ($RadioButton4.Checked -eq $true) {$WhichChoice="Check_For_Me"}
    elseif ($RadioButton5.Checked -eq $true) {$WhichChoice="Ready_for_This"}
    return , $WhichChoice
}
# How Big is the screen
Add-Type -AssemblyName System.Windows.Forms
$ThisScreen=[System.Windows.Forms.Screen]::PrimaryScreen
$thisbounds=$ThisScreen.Bounds
$ThisBoundsWidth=$thisbounds.Width
$ThisBoundsHeight=$thisbounds.Height
$ThisPerc=100*$ThisBoundsWidth/$ThisBoundsHeight
$Widescreen=($ThisPerc -gt 140)
$thisWorkingArea=$ThisScreen.WorkingArea
$ThisWorkingWidth=$thisWorkingArea.Width
$ThisWorkingHeight=$thisWorkingArea.Height
# Icon
$iconBase64      = [Convert]::ToBase64String((Get-Content "C:\Materials\PowerShell\Labs\lab.ico" -Encoding Byte))
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$iconImage       = [System.Drawing.Image]::FromStream($stream, $true)

$objForm = New-Object System.Windows.Forms.Form 
$objForm.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())
$objForm.Text = "ICM 7 Labs"
# Not sure why the working area is too big so shrink it slightly
$objFormWidth=$ThisWorkingWidth
$objFormHeight=$ThisWorkingHeight -40 #-32
$objForm.ClientSize = "$objFormWidth, $objFormHeight" 
$objFormFontSize=[int]($objFormHeight/100)
$objForm.font =[System.Drawing.Font]::new('Times New Roman', $objFormFontSize, [System.Drawing.FontStyle]::Regular)
$objForm.StartPosition = "CenterScreen"

$groupBoxRTF = New-Object System.Windows.Forms.GroupBox
$groupBoxRTF.Location = New-Object System.Drawing.Size(10,55) #(10,10)
if ($Widescreen)
{
 $groupBoxRTFWidth=[int](($objFormWidth -64) /3)
}
else
{
 $groupBoxRTFWidth=[int](($objFormWidth -64) /2 )
}
$groupBoxRTFHeight= $objFormHeight -100
$groupBoxRTF.ClientSize = "$groupBoxRTFWidth,$groupBoxRTFHeight"
$objForm.Controls.Add($groupBoxRTF)

$RTFBit = New-Object System.Windows.Forms.RichTextBox
$RTFBit.ClientSize=  $groupBoxRTF.ClientSize
$groupBoxRTF.Controls.Add($RTFBit)

$groupBoxControls = New-Object System.Windows.Forms.GroupBox
$groupBoxControlsWidth=$objFormWidth - $groupBoxRTFWidth -40
$groupBoxControlsHeight= $objFormHeight -50
$groupBoxControlsOffsetX=$objFormWidth - $groupBoxControlsWidth -20
$groupBoxControlsFontSize=[int]($groupBoxControlsHeight/100)
$groupBoxControls.Location = New-Object System.Drawing.Size($groupBoxControlsOffsetX,10)
$groupBoxControls.ClientSize = "$groupBoxControlsWidth,$groupBoxControlsHeight"
$groupBoxControls.font =[System.Drawing.Font]::new('Times New Roman', $groupBoxControlsFontSize, [System.Drawing.FontStyle]::Regular)
#$groupBoxControls.text = "Labs:"
$objForm.Controls.Add($groupBoxControls)
 
$DropLableWidth=$groupBoxControlsWidth-80
$LabDropDownLabel = new-object System.Windows.Forms.Label
$LabDropDownLabelOffsetX=20
$LabDropDownLabelOffsetY=4*$groupBoxControlsFontSize
$LabDropDownLabel.Location = new-object System.Drawing.Size($LabDropDownLabelOffsetX,20)
$LabDropDownLabel.size = new-object System.Drawing.Size($DropLableWidth,20)
$LabDropDownLabel.Text = "First, choose The Lab:"
$groupBoxControls.Controls.Add($LabDropDownLabel)

$LabDropDownOffsetX=$LabDropDownLabelOffsetX
$LabDropDownOffsetY=$LabDropDownLabelOffsetY+4*$groupBoxControlsFontSize
$LabDropDown = new-object System.Windows.Forms.ComboBox
$LabDropDown.Location = new-object System.Drawing.Size($LabDropDownOffsetX,$LabDropDownOffsetY)
$LabDropDownWidth=$groupBoxControlsWidth -40 #*2 /3
$LabDropDown.Size = new-object System.Drawing.Size($LabDropDownWidth,30)
ForEach ($Item in $LabDropDownArray)
{
    $curr_Kit= $Item
	$dummyVar=$LabDropDown.Items.Add($curr_Kit)
}
$LabDropVar=
{
    If ($LabDropDown.text -eq "") {$SelectButton.Enabled=$true}
    Else
	{
	 $TaskDropDown.Enabled=$true
	 $Global:LabPrefix=Whatis-LabDropDown
	 [array]$TaskDropDownArray = Get-ChildItem $RTFLocation\$Global:LabPrefix\*.rtf | Select-Object BaseName
	 $TaskDropDownArray = $TaskDropDownArray -replace '@{BaseName=',''
	 $TaskDropDownArray = $TaskDropDownArray -replace '}',''
	 $TaskDropDown.Items.Clear()
     $TaskDropDown.SelectedIndex=-1
     $TaskDropDown.SelectedIndex=-1
     #$TaskDropdown.SelectedValue=""
     #$TaskDropdown.SelectionLength=0
     $RadioButton1.Checked = $true
     $ProgressTextBox.text = " "
     $ProgressTextBox.BackColor = "Black"
     	 ForEach ($Item in $TaskDropDownArray)
	 	{
			    $curr_task= $Item
				$dummyVar=$TaskDropDown.Items.Add($curr_task)
		}
	}
}
$LabDropDown.add_SelectedIndexChanged($LabDropVar)
$groupBoxControls.Controls.Add($LabDropDown)

$TaskDropDownLabel = new-object System.Windows.Forms.Label
$TaskDropDownLabelOffsetX=$LabDropDownLabelOffsetX
$TaskDropDownLabelOffsetY=$LabDropDownOffsetY+4*$groupBoxControlsFontSize
$TaskDropDownLabel.Location = new-object System.Drawing.Size($TaskDropDownLabelOffsetX,$TaskDropDownLabelOffsetY)
$TaskDropDownLabel.size = new-object System.Drawing.Size($DropLableWidth,20)
$TaskDropDownLabel.Text = "Then, choose the Task:"
$groupBoxControls.Controls.Add($TaskDropDownLabel)

$TaskDropDown = new-object System.Windows.Forms.ComboBox
$TaskDropDownOffsetX=$TaskDropDownLabelOffsetX
$TaskDropDownOffsetY=$TaskDropDownLabelOffsetY+4*$groupBoxControlsFontSize
$TaskDropDown.Location = new-object System.Drawing.Size($TaskDropDownOffsetX,$TaskDropDownOffsetY)
$TaskDropDownWidth=$groupBoxControlsWidth -40 #*2 /3
$TaskDropDown.Size = new-object System.Drawing.Size($TaskDropDownWidth,30)
$TaskDropDown.Enabled=$false
$TskDropVar=
{
    If ($TaskDropDown.text -eq "") {$SelectButton.Enabled=$true}
    Else {
    $CheckboxOnlyInstructions.Checked=$false #$true #It was annoying showing only the instructions each time a task was chosen
	$groupBoxActions.Enabled=$true
	$groupBoxActions.Visible=$true
    $RadioButton1.Checked = $true
    $Global:SelectedTask=Whatis-TaskDropDown
	$RTFfile=$Global:SelectedTask+'.rtf'
	$DOfile=$Global:SelectedTask+'-Do.ps1'
	$RadioButton2.Enabled=(Test-Path $DOfile) 
	$UNDOfile=$Global:SelectedTask+'-Undo.ps1'
	$RadioButton3.Enabled=(Test-Path $UNDOfile)  
	$CHECKfile=$Global:SelectedTask+'-Check.ps1'
	$RadioButton4.Enabled=(Test-Path $CHECKfile) 
	$UPTOfile=$Global:SelectedTask+'-Upto.ps1'
	$RadioButton5.Enabled=(Test-Path $UPTOfile)
	$RTFBit.LoadFile($RTFfile)
    if ($RadioButton2.Enabled)
    {
     if ($RadioButton3.Enabled)
     {
      $ProgressTextBox.text = "" #Whatis-LabDropDown+" "+Whatis-TaskDropDown
      $ProgressTextBox.BackColor = "Black"
     }
     else
     {
      $ProgressTextBox.text = "Note: This Lab Cannot be Undone"
      $ProgressTextBox.BackColor = "Red"
     }
    }
    else
    {
     $ProgressTextBox.text = "Note: This Lab is not currently Automated"
     $ProgressTextBox.BackColor = "Red"
    }
     $SelectButton.visible=($RadioButton2.Enabled -or $RadioButton3.Enabled -or $RadioButton4.Enabled -or $RadioButton5.Enabled)
     $RadioButton2.Visible=$SelectButton.visible
     $RadioButton3.Visible=$SelectButton.visible
     $RadioButton4.Visible=$SelectButton.visible
     $RadioButton5.Visible=$SelectButton.visible
	}
}
$TaskDropDown.add_SelectedIndexChanged($TskDropVar)
$groupBoxControls.Controls.Add($TaskDropDown)

$groupBoxActions = New-Object System.Windows.Forms.GroupBox
$groupBoxActionsOffsetX=$TaskDropDownOffsetX
$groupBoxActionsOffsetY=$TaskDropDownOffsetY+4*$groupBoxControlsFontSize
$groupBoxActions.Location = New-Object System.Drawing.Size($groupBoxActionsOffsetX,$groupBoxActionsOffsetY)
$groupBoxActionsWidth=$groupBoxControlsWidth - 40 #[int]($groupBoxControlsWidth * 7 / 8)
$groupBoxActionsHeight= $groupBoxControlsHeight - $groupBoxActionsOffsetY -20  # 305
$groupBoxActions.ClientSize = "$groupBoxActionsWidth,$groupBoxActionsHeight"
$groupBoxActions.Enabled=$false
$groupBoxActions.Visible=$false
$groupBoxActions.text = "Action:" 
$groupBoxControls.Controls.Add($groupBoxActions)

$RadioButtonsXOffset=30
$RadioButtonsYGap=4*$groupBoxControlsFontSize
$ThisRadioButtonYOffset=0
$ThisRadioButtonYOffset+=$RadioButtonsYGap
$RadiobuttonsTxtWdth=$groupBoxControlsWidth-80 
$RadioButton1 = New-Object System.Windows.Forms.RadioButton 
$RadioButton1.Location = new-object System.Drawing.Point($RadioButtonsXOffset,$ThisRadioButtonYOffset) 
$RadioButton1.size = New-Object System.Drawing.Size($RadiobuttonsTxtWdth,20) 
$RadioButton1.Checked = $true 
$RadioButton1.Text = "Follow The Instructions on the left"  
$RadioButton1.add_CheckedChanged({if ($RadioButton1.get_checked()){$CheckboxOnlyInstructions.Checked=$true;$CheckboxOnlyInstructions.Enabled=$RadioButton1.Checked;$ProgressTextBox.text = " ";$SelectButton.Enabled=$false;$vSphereLic.Enabled=$false;$vCenterLic.Enabled=$false;$ProgressTextBox.BackColor = "Black"}})
$groupBoxActions.Controls.Add($RadioButton1)
$ThisRadioButtonYOffset+=$RadioButtonsYGap 
$RadioButton2 = New-Object System.Windows.Forms.RadioButton
$RadioButton2.Location = new-object System.Drawing.Point($RadioButtonsXOffset,$ThisRadioButtonYOffset)
$RadioButton2.size = New-Object System.Drawing.Size($RadiobuttonsTxtWdth,20)
$RadioButton2.Text = "Do This Task For Me"  
$RadioButton2.add_CheckedChanged({if ($RadioButton2.get_checked()){$CheckboxOnlyInstructions.Enabled=$RadioButton1.Checked;$ProgressTextBox.text = " ";$SelectButton.Enabled=$true;$VSPHLfile=$Global:SelectedTask+'.vSphere';$vSphereLic.Enabled=(Test-Path $VSPHLfile);$vSphereLicLabel.Enabled=$vSphereLic.Enabled;$VCLfile=$Global:SelectedTask+'.vCenter';$vCenterLic.Enabled=(Test-Path $VCLfile);$vCenterLicLabel.Enabled=$vCenterLic.Enabled;$ProgressTextBox.BackColor = "Black"}})
$groupBoxActions.Controls.Add($RadioButton2)
$ThisRadioButtonYOffset+=$RadioButtonsYGap
$RadioButton3 = New-Object System.Windows.Forms.RadioButton
$RadioButton3.Location = new-object System.Drawing.Point($RadioButtonsXOffset,$ThisRadioButtonYOffset)
$RadioButton3.size = New-Object System.Drawing.Size($RadiobuttonsTxtWdth,20)
$RadioButton3.Text = "Undo This Task For Me"  
$RadioButton3.add_CheckedChanged({if ($RadioButton3.get_checked()){$CheckboxOnlyInstructions.Enabled=$RadioButton1.Checked;$ProgressTextBox.text = " ";$SelectButton.Enabled=$true;$VSPHLfile=$Global:SelectedTask+'.vSphere';$vSphereLic.Enabled=(Test-Path $VSPHLfile);$vSphereLicLabel.Enabled=$vSphereLic.Enabled;$VCLfile=$Global:SelectedTask+'.vCenter';$vCenterLic.Enabled=(Test-Path $VCLfile);$vCenterLicLabel.Enabled=$vCenterLic.Enabled;$ProgressTextBox.BackColor = "Black"}})
$groupBoxActions.Controls.Add($RadioButton3)
$ThisRadioButtonYOffset+=$RadioButtonsYGap 
$RadioButton4 = New-Object System.Windows.Forms.RadioButton
$RadioButton4.Location = new-object System.Drawing.Point($RadioButtonsXOffset,$ThisRadioButtonYOffset)
$RadioButton4.size = New-Object System.Drawing.Size($RadiobuttonsTxtWdth,20)
$RadioButton4.Text = "Check This Task For Me"  
$RadioButton4.add_CheckedChanged({if ($RadioButton4.get_checked()){$CheckboxOnlyInstructions.Enabled=$RadioButton1.Checked;$ProgressTextBox.text = " ";$SelectButton.Enabled=$true;$VSPHLfile=$Global:SelectedTask+'.vSphere';$vSphereLic.Enabled=(Test-Path $VSPHLfile);$vSphereLicLabel.Enabled=$vSphereLic.Enabled;$VCLfile=$Global:SelectedTask+'.vCenter';$vCenterLic.Enabled=(Test-Path $VCLfile);$vCenterLicLabel.Enabled=$vCenterLic.Enabled;$ProgressTextBox.BackColor = "Black"}})
$groupBoxActions.Controls.Add($RadioButton4)
$ThisRadioButtonYOffset+=$RadioButtonsYGap 
$RadioButton5 = New-Object System.Windows.Forms.RadioButton
$RadioButton5.Location = new-object System.Drawing.Point($RadioButtonsXOffset,$ThisRadioButtonYOffset)
$RadioButton5.size = New-Object System.Drawing.Size($RadiobuttonsTxtWdth,20)
$RadioButton5.Text = "Do All Tasks Leading Up To This One"  
$RadioButton5.add_CheckedChanged({if ($RadioButton5.get_checked()){$CheckboxOnlyInstructions.Enabled=$RadioButton1.Checked;$ProgressTextBox.text = " ";$SelectButton.Enabled=$true;$U2VSPHLfile=$Global:SelectedTask+'.U2vSphere';$vSphereLic.Enabled=(Test-Path $U2VSPHLfile);$vSphereLicLabel.Enabled=$vSphereLic.Enabled;$U2VCLfile=$Global:SelectedTask+'.U2vCenter';$vCenterLic.Enabled=(Test-Path $U2VCLfile);$vCenterLicLabel.Enabled=$vCenterLic.Enabled;$ProgressTextBox.BackColor = "Black"}})
$groupBoxActions.Controls.Add($RadioButton5)

$objForm.KeyPreview = $True
$SelectButton_OnClick=  
{ 
$Global:RadioChosen=RadioChoice
        if ($Global:RadioChosen -ne "As_Written")
        {
         $doit=$true
         #Only run License scripts if the keys "Look" right
         if ($vCenterLic.Enabled) {$doit=($vCenterLic.Text -match '^[a-z0-9]{5}-[a-z0-9]{5}-[a-z0-9]{5}-[a-z0-9]{5}-[a-z0-9]{5}$')}
         if ($doit -and ($vSphereLic.Enabled)) {$doit=($vSphereLic.Text -match '^[a-z0-9]{5}-[a-z0-9]{5}-[a-z0-9]{5}-[a-z0-9]{5}-[a-z0-9]{5}$')}
         if ($doit)
         {
          $NewobjFormWidth=$groupBoxRTFWidth+20
          $objForm.ClientSize = "$NewobjFormWidth,55"
          $ProgressTextBox.BackColor = "Black"
          $ProgressTextBox.text = " "
          if ($Global:RadioChosen -eq "Do_For_Me"){$DOfile=$Global:SelectedTask+"-Do.ps1";$SelectButton.Enabled=$false;$groupBoxActions.Enabled=$false;$ProgressTextBox.text = "Starting 'Do' Task..."; . $DOfile;$SelectButton.Enabled=$true;$groupBoxActions.Enabled=$true}
          elseif ($Global:RadioChosen -eq "Undo_For_Me"){$UNDOfile=$Global:SelectedTask+'-Undo.ps1';$SelectButton.Enabled=$false;$groupBoxActions.Enabled=$false;$ProgressTextBox.text = "Starting 'Undo' Task..."; . $UNDOfile;$SelectButton.Enabled=$true;$groupBoxActions.Enabled=$true}
          elseif ($Global:RadioChosen -eq "Check_For_Me"){$CHECKfile=$Global:SelectedTask+'-Check.ps1';$SelectButton.Enabled=$false;$groupBoxActions.Enabled=$false;$ProgressTextBox.text = "Starting 'Check' Task..."; . $CHECKfile;$SelectButton.Enabled=$true;$groupBoxActions.Enabled=$true}
          elseif ($Global:RadioChosen -eq "Ready_for_This"){$UPTOfile=$Global:SelectedTask+'-Upto.ps1';$SelectButton.Enabled=$false;$groupBoxActions.Enabled=$false; . $UPTOfile;$SelectButton.Enabled=$true;$groupBoxActions.Enabled=$true}
          $objForm.ClientSize = "$objFormWidth, $objFormHeight"
         }
         else
         {
          if (-not ($vCenterLic.Text -match '^[a-z0-9]{5}-[a-z0-9]{5}-[a-z0-9]{5}-[a-z0-9]{5}-[a-z0-9]{5}$')) {$vCenterLic.Text=""}
          if (-not ($vSphereLic.Text -match '^[a-z0-9]{5}-[a-z0-9]{5}-[a-z0-9]{5}-[a-z0-9]{5}-[a-z0-9]{5}$')) {$vSphereLic.Text=""}
          $ProgressTextBox.BackColor = "Red"
          $ProgressTextBox.text = "Licenses look like:  xxxxx-xxxxx-xxxxx-xxxxx-xxxxx (re-select task)"
          $groupBoxActions.Enabled=$false
        }
        }
}
$SelectButton = New-Object System.Windows.Forms.Button 
$SelectButtonOffsetX=10
$SelectButtonOffsetY=$ThisRadioButtonYOffset+$RadioButtonsYGap
$SelectButton.TabIndex = 12 
$SelectButton.Name = "buttonDot"
$SelectButton.Location = New-Object System.Drawing.Size($SelectButtonOffsetX,$SelectButtonOffsetY)
$SelectButton.Size = New-Object System.Drawing.Size(75,23)
$SelectButton.Text = "Select"
$SelectButton.Enabled=$False
$SelectButton.DataBindings.DefaultDataSourceUpdateMode = 0 
$SelectButton.add_Click($SelectButton_OnClick)
$groupBoxActions.Controls.Add($SelectButton)

$QuitButton = New-Object System.Windows.Forms.Button
$QuitOffsetX=$groupBoxRTFWidth-65 #$objFormWidth-100
$QuitOffsetY=$objFormHeight-33
$QuitButton.Location = New-Object System.Drawing.Size($QuitOffsetX,$QuitOffsetY)
$QuitButton.Size = New-Object System.Drawing.Size(75,23)
$QuitButton.Text = "Quit"
$QuitButton.Add_Click({$objForm.Close()})
$objForm.Controls.Add($QuitButton)

$vCenterLicLabel = New-Object System.Windows.Forms.Label
$vCenterLicLabelOffsetY=$groupBoxActionsHeight - 20*$groupBoxControlsFontSize #$SelectButtonOffsetY+35
$vCenterLicLabelOffsetX=20
$vCenterLicLabel.Location = New-Object System.Drawing.Size($vCenterLicLabelOffsetX,$vCenterLicLabelOffsetY) 
$vCenterLicLabel.Size = New-Object System.Drawing.Size($RadiobuttonsTxtWdth,20) 
$vCenterLicLabel.Text = "vCenter Licence:" 
$vCenterLicLabel.Enabled=$false
$groupBoxActions.Controls.Add($vCenterLicLabel)

$vCenterLic = New-Object System.Windows.Forms.TextBox
$vCenterLicOffsetY=$vCenterLicLabelOffsetY+4*$groupBoxControlsFontSize
$vCenterLicOffsetX=10
$vCenterLicWidth=$groupBoxActionsWidth -20
$vCenterLic.Location = New-Object System.Drawing.Size($vCenterLicOffsetX,$vCenterLicOffsetY) 
$vCenterLic.Size = New-Object System.Drawing.Size($vCenterLicWidth,20)
$vCenterLic.Add_TextChanged({
    if ($this.Text -match '[^a-z\-0-9]') {
        $cursorPos = $this.SelectionStart
        $this.Text = $this.Text -replace '[^a-z 0-9]',''
        # move the cursor to the end of the text:
        # $this.SelectionStart = $this.Text.Length
        # or leave the cursor where it was before the replace
        $this.SelectionStart = $cursorPos - 1
        $this.SelectionLength = 0
    }
})
$vCenterLic.Enabled=$false
#$vCenterLic.Visible=$false # Not Visible until enabled
$groupBoxActions.Controls.Add($vCenterLic)

$vSphereLicLabel = New-Object System.Windows.Forms.Label
$vSphereLicLabelOffsetY=$vCenterLicOffsetY+4*$groupBoxControlsFontSize
$vSphereLicLabelOffsetX=20
$vSphereLicLabel.Location = New-Object System.Drawing.Size($vSphereLicLabelOffsetX,$vSphereLicLabelOffsetY) 
$vSphereLicLabel.Size = New-Object System.Drawing.Size($RadiobuttonsTxtWdth,20) 
$vSphereLicLabel.Text = "vSphere Enterprise Plus Licence:" 
$vSphereLicLabel.Enabled=$false
$groupBoxActions.Controls.Add($vSphereLicLabel)

$vSphereLic = New-Object System.Windows.Forms.TextBox
$vSphereLicOffsetY=$vSphereLicLabelOffsetY+4*$groupBoxControlsFontSize
$vSphereLicOffsetX=10
$vSphereLicWidth=$groupBoxActionsWidth -20
$vSphereLic.Location = New-Object System.Drawing.Size($vSphereLicOffsetX,$vSphereLicOffsetY) 
$vSphereLic.Size = New-Object System.Drawing.Size($vSphereLicWidth,20)
$vSphereLic.Add_TextChanged({
    if ($this.Text -match '[^a-z\-0-9]') {
        $cursorPos = $this.SelectionStart
        $this.Text = $this.Text -replace '[^a-z 0-9]',''
        # move the cursor to the end of the text:
        # $this.SelectionStart = $this.Text.Length

        # or leave the cursor where it was before the replace
        $this.SelectionStart = $cursorPos - 1
        $this.SelectionLength = 0
    }
})
$vSphereLic.Enabled=$false
#$vSphereLic.Visible=$false # Not Visible until enabled
$groupBoxActions.Controls.Add($vSphereLic)

$ProgressTextBox = New-Object System.Windows.Forms.TextBox
$ProgressTextBoxOffsetY=$objFormHeight-73
$ProgressTextBoxOffsetX=10
$ProgressTextBoxWidth=$groupBoxRTFWidth
$ProgressTextBoxHeight=300
$ProgressTextBox.Location = New-Object System.Drawing.Size($ProgressTextBoxOffsetX,15) # ($ProgressTextBoxOffsetX,$ProgressTextBoxOffsetY) 
$ProgressTextBox.Size = New-Object System.Drawing.Size($ProgressTextBoxWidth,$ProgressTextBoxHeight)
$ProgressTextBox.foreColor = "White" 
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.FONT = [System.Drawing.Font]::new('Times New Roman', 16, [System.Drawing.FontStyle]::Regular) 
$ProgressTextBox.text = " "
$objForm.Controls.Add($ProgressTextBox)

$CheckboxOnlyInstructions = new-object System.Windows.Forms.Checkbox
$OnlyInstructionsOffsetX=20#$objFormWidth-100
$OnlyInstructionsOffsetY=$objFormHeight-33
$CheckboxOnlyInstructions.Location = new-object System.Drawing.Size($OnlyInstructionsOffsetX,$OnlyInstructionsOffsetY)
$CheckboxOnlyInstructions.size = new-object System.Drawing.Size(20,20)
$CheckboxOnlyInstructions.Add_CheckStateChanged(
 {
  IF ($CheckboxOnlyInstructions.Checked)
  {
   $NewobjFormWidth=$groupBoxRTFWidth+20
   $objForm.ClientSize = "$NewobjFormWidth,$objFormHeight"
   $ProgressTextBox.Visible=$false
  }
  ELSE
  {
   $objForm.ClientSize = "$objFormWidth, $objFormHeight"
   $QuitButton.Location = New-Object System.Drawing.Size($QuitOffsetX,$QuitOffsetY)
   $ProgressTextBox.Visible=$true
  }
 }
 )
$objForm.Controls.Add($CheckboxOnlyInstructions)

$OnlyInstructionsLabl = New-Object System.Windows.Forms.Label
$OnlyInstructionsLblOffsetX=$OnlyInstructionsOffsetX +20
$OnlyInstructionsLblOffsetY=$OnlyInstructionsOffsetY+3
$OnlyInstructionsLabl.Location = New-Object System.Drawing.Size($OnlyInstructionsLblOffsetX,$OnlyInstructionsLblOffsetY)
$OnlyInstructionsLabl.Size = New-Object System.Drawing.Size(170,15) 
$OnlyInstructionsLabl.Text = "Show Just The Task Instructions?" 
$objForm.Controls.Add($OnlyInstructionsLabl)


$objForm.Topmost = $false
$objForm.Add_Shown({$objForm.Activate()})
$answer= $objForm.ShowDialog()