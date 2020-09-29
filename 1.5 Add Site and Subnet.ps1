# Create new AD site
New-ADReplicationSite -Name "Kortrijk"

# Add subnet to newly created site (-Location is a discription of where the subnet is located)
New-ADReplicationSubnet -Name "192.168.1.0/24" -Site "Kortrijk" -Location "Kortrijk"

# Move DC to newly created site
Move-ADDirectoryServer -Identity "win13-DC1" -Site "Kortrijk"

# Check if default site is present and ask to delete default site
[System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest().Sites | ForEach-Object {
    $site_name = $_.Name
    if ($site_name -eq "Default-First-Site-Name") {
        $isOk = Read-Host "Default-First-Site-Name has been detected, do you want to delete it? (Y/N)"
        if ($isOk -eq "Y") {
            Write-Host "Default-First-Site-Name will be deleted"
            Remove-ADReplicationSite -Identity $site_name
        }
    }
}