# Create DNS reverse lookup zone
Add-DnsServerPrimaryZone -NetworkID "192.168.1.0/24" -ReplicationScope "Domain"