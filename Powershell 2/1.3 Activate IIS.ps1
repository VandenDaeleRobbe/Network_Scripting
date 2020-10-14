#
# Create session with MS
#
$cred = Get-Credential -Message "Credentials of server to configure"
$session = New-PSSession -Credential $cred -ComputerName "win13-MS"

#
# Install IIS
#
Invoke-Command -Session $session {
    Install-WindowsFeature -name Web-Server -IncludeManagementTools
}