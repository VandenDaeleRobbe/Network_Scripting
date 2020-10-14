#
# Variables
#
$script_path = "\\win13-MS\c$\logonscriptnew.ps1"

#
# Create session with MS
#
$cred = Get-Credential -Message "Credentials of server to configure"
$session = New-PSSession -Credential $cred -ComputerName "win13-MS"

#
# Create logon script
#
Invoke-Command -Session $session {
    # Create script
    '$net = New-Object -ComObject WScript.Network' | Out-File -FilePath $using:script_path -Append
    '$net.MapNetworkDrive("P:", "\\win13-MS\public")' | Out-File -FilePath $using:script_path -Append
}

#
# Get users of group and add logon script
#
Get-ADGroupMember -Identity "personeel" | ForEach-Object {
    $group_name = $_.SamAccountName
    Get-ADGroupMember -Identity $group_name | ForEach-Object {
        $acc_name = $_.SamAccountName
        Get-ADUser -Filter "SamAccountName -like '$acc_name'" | Set-ADUser -ScriptPath "$script_path"
    }
}

#
# Exit session
#
Remove-PSSession $session