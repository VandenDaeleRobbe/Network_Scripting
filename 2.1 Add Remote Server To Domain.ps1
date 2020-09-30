# Variables
$domain = Get-ADDomain
$dns_root = $domain.DNSRoot
$computer_name = "win13-MS"

# Add MS to domain
Add-Computer -DomainName $dns_root -ComputerName $computer_name -Credential $dns_root\administrator -LocalCredential win13-MS\administrator -Restart