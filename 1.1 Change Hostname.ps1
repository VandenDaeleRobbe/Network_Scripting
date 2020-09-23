# Get userinput for a new computername
$newComputerName = Read-Host "New computer name to set"
$isOk = Read-Host "The system needs to be restarted. Do you want to restart now? (Y/N)"

# Set computername and restart if asked
if ($isOk -eq "Y") {
    Rename-Computer -NewName $newComputerName -Restart
} else {
    Rename-Computer -NewName $newComputerName
    Write-Host "Restart the machine for the changes to take place"
}