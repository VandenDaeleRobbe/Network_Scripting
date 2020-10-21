#
# Variables
#
$filter = Read-Host "Hostname filter (empty for no filter)"
$scope = "192.168.1.0"
$macs = @()

#
# Filter DHCP leases
#
if ($filter -eq "") {
    Get-DhcpServerv4Lease -ComputerName "win13-dc1"-ScopeId $scope | ForEach-Object {
        $macs += $_.ClientId
    }
} else {
    Get-DhcpServerv4Lease -ComputerName "win13-dc1"-ScopeId $scope | Where-Object { $_.HostName -match $filter } | ForEach-Object {
        $macs += $_.ClientId
    }
}

#
# Send WOL
#
Foreach ($index in $macs) {
    Write-Host "Sending magic packet to client $index ..."

    # Create magic packet
    $macByteArray = $index -split "[-]" | ForEach-Object { [Byte] "0x$_" }
    [Byte[]] $magicPacket = (,0xFF * 6) + ($macByteArray  * 16)

    # Send magic packet
    $udpClient = New-Object System.Net.Sockets.UdpClient
    $udpClient.Connect(([System.Net.IPAddress]::Broadcast),9)
    $udpClient.Send($magicPacket,$magicPacket.Length)
    $udpClient.Close()
}