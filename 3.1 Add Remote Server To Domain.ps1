# Variables
$domain = Get-ADDomain
$dns_root = $domain.DNSRoot
$computer_name = Read-Host "Give the computername of the machine you want to make a member of the domain"

# Add MS to domain
Add-Computer -DomainName $dns_root -ComputerName $computer_name -Credential $dns_root\administrator -LocalCredential win13-MS\administrator -Restart