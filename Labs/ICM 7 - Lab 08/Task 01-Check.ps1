# MODULE TO Configuring Active Directory: Joining a Domain
$ProgressTextBox.BackColor = "Black"
$ProgressTextBox.text=$ProgressTextBox.text+" (Configuring Active Directory: Joining a Domain)"
# a delay so the message can be seen
Start-sleep 5
Clear-Host
# Using Variables to make changes easier
$CurrentVC="sa-vcsa-01.vclass.local"
$CurrentVCLocUser="root"
$CurrentVCLocPass="VMware1!"
$CurrentADDomain="vclass.local"
$CurrentADDomainU="administrator@vclass.local"
$CurrentADDomainP="VMware1!"
$secpasswd = ConvertTo-SecureString $CurrentVCLocPass -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential($CurrentVCLocUser, $secpasswd)
$SessionID = New-SSHSession -AcceptKey  -ComputerName $CurrentVC -Credential $Credentials #Connect Over SSH
$CurrentVCCommand1 = "/opt/likewise/bin/domainjoin-cli query"
Invoke-SSHCommand -OutVariable result -Index $sessionid.sessionid -Command $CurrentVCCommand1   >$null 2>&1 # Invoke Command Over SSH
$outit=$result.output
#$ProgressTextBox.text=$outit
#$ProgressTextBox.text=$outit[1]
if ($outit[1] -ne "Domain = VCLASS.LOCAL")
{
 $ProgressTextBox.BackColor="Red"
 $ProgressTextBox.text=""
 $ProgressTextBox.text="Redo Lab 8 ... $CurrentVC is Not in Domain $CurrentADDomain"
 # a delay so the message can be seen
 Start-sleep 5
}
else
{
 $ProgressTextBox.BackColor="Green"
 $ProgressTextBox.text=""
 $ProgressTextBox.text="$CurrentVC is in Domain $CurrentADDomain"
}
# End of Module