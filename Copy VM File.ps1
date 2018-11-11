<#
Solution: Hyper-V File Transfer
Purpose: Enables VM Integration Services for file transfer and transfers files from host computer to Hyper-V Virtual Machines.
Version: 1.0 - November 10th, 2018
 
This script is provided "AS IS" with no warranties, confers no rights and 
is not supported by the authors or Deployment Artist. 
 
Author - Ashe [AstralMelancholy.com]
#>

#Check for VM Integration Services on the VM and enable if they are not

$VMName = Read-Host -Prompt "Please input the name of the VM in Hyper-V"
[String]$VMIntServ = Get-VM -Name $VMName | Get-VMIntegrationService | ? {-not($_.Enabled)}

Write-Host "Checking VM Integration Services..."
If ($VMIntServ -eq "") {
Write-Host "Success."
}
Else{
Write-Host "VM Integration Services are not enabled for file transfer on this VM. Enabling now."

#Second check for VM Integration Services

Enable-VMIntegrationService -Name "Guest Service Interface" -VMName $VMName
[String]$VMIntServ = Get-VM -Name $VMName | Get-VMIntegrationService | ? {-not($_.Enabled)}
If ($VMIntServ -eq "") {
Write-Host "VM Integration Services enabled successfully."
} 
Else{
Write-Host "VM Integration Activation failed"
}
}



#Gather user input for file location and destination and copy files, then ask user if they want to go again

$Repeat = 1
While ($Repeat -eq 1) {

$Source_Folder = Read-Host -Prompt "Please input the file path of the file you want to copy."
$Destination_Folder = Read-Host -Prompt "Please input the file path of the destination folder in the VM"


Copy-VMFile $VMName -SourcePath $Source_Folder -DestinationPath $Destination_Folder -CreateFullPath -FileSource Host
Write-Host "File was copied successfully."

$Repeat = Read-Host -Prompt "Would you like to copy another file? Press 1 for yes and 2 for no."

}