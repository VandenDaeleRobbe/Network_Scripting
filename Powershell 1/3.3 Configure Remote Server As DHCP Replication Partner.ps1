#
# Fixed variables
#
$DNS_NAME_DC1 = "win13-DC1.intranet.mijnschool.be"
$DNS_NAME_DC2 = "win13-DC2.intranet.mijnschool.be"
$IP_ADDRESS_DC2 = "192.168.1.3"
$SCOPE_ID = "192.168.1.0"


#
# Get credentials and start session
#
$cred = Get-Credential -Message "Credentials of server to configure"
$sess = New-PSSession -Credential $cred -ComputerName "WIN13-DC2"
Enter-PSSession $sess


#
# Install DHCP service and set replication partner
#
Invoke-Command -Session $sess {
    Install-WindowsFeature DHCP -IncludeManagementTools
    Add-DhcpServerInDC -DnsName $using:DNS_NAME_DC2 -IPAddress $using:IP_ADDRESS_DC2 # $using: is needed to use the local variables in remote session
}


#
# Exit session
#
Exit-PSSession
Remove-PSSession $sess


#
# Set server as replication partner
#
Add-DhcpServerv4Failover -ComputerName $DNS_NAME_DC1 -Name "DC2-Failover"-PartnerServer $DNS_NAME_DC2 -ScopeId $SCOPE_ID -SharedSecret "P@ssw0rd"