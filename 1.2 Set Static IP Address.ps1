#Get physical network adapter
$nic=Get-NetAdapter | where {$_.MediaType -eq "802.3"}
$ip_address = Read-Host "Give the IP address to set"

#Romove all existing instances
Remove-NetIPAddress -InterfaceAlias $nic.Name -Confirm:$false
Remove-NetRoute -InterfaceAlias $nic.Name -Confirm:$false
#Set IP address and dns servers
New-NetIPAddress -IPAddress $ip_address -DefaultGateway 192.168.1.1 -PrefixLength 24 -InterfaceAlias $nic.Name
Set-DnsClientServerAddress -ServerAddresses ("172.20.0.2", "172.20.0.3") -InterfaceAlias $nic.Name