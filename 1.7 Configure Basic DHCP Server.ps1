# Variables
$dns_name = "win13-DC1.intranet.mijnschool.be"
$ip_address_GW = "192.168.1.1"
$ip_address_DC1 = "192.168.1.2"
$ip_address_DC2 = "192.168.1.3"
$ip_address_printer = "192.168.1.5"
$mac_address_printer = "b8-e9-37-3e-55-86"
$scope_id = "192.168.1.0"

# Install DHCP server role and authorize in AD
Install-WindowsFeature DHCP -IncludeManagementTools
Add-DhcpServerInDC -DnsName $dns_name -IPAddress $ip_address_DC1

# Add a new scope, exclude range, add options and reserve IP for MAC address
Add-DhcpServerv4Scope -Name "Default scope" -StartRange 192.168.1.1 -EndRange 192.168.1.254 -SubnetMask 255.255.255.0 -State Active
Add-DhcpServerv4ExclusionRange -ScopeID $scope_id -StartRange 192.168.1.1 -EndRange 192.168.1.10
Set-DhcpServerv4OptionValue -OptionID 3 -Value $ip_address_GW -ScopeID $scope_id # Default router
Set-DhcpServerv4OptionValue -OptionID 6 -Value $ip_address_DC1,$ip_address_DC2 -ScopeID $scope_id -Force # DNS servers
Add-DhcpServerv4Reservation -ScopeId $scope_id -IPAddress $ip_address_printer -ClientId $mac_address_printer -Description "Reservation for printer"