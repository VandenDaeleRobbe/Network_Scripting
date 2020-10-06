#
# Get credentials and start session
#
$cred = Get-Credential -Message "Local remote server credential"
$sess = New-PSSession -Credential $cred -ComputerName "WIN13-DC2"
Enter-PSSession $sess


#
# Configure server as DC and GC
#
Invoke-Command -Session $sess {
    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
    $domain_cred = Get-Credential -Message "Domain credentials to promote DC"
    Install-ADDSDomainController -InstallDns -Credential $domain_cred -DomainName "intranet.mijnschool.be" -Force
}


#
# Exit session
#
Exit-PSSession
Remove-PSSession $sess