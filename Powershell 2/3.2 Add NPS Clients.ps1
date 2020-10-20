#
# Install NPS
#
Install-WindowsFeature NPAS -IncludeManagementTools

#
# Read CSV
#
$file = Import-Csv -Path "C:\Users\Administrator\Desktop\Network Scripting\Network_Scripting\Docs\RadiusClients.csv" -Delimiter ";"
$file | Format-Table

#
# Create radius clients
#
$FILE | ForEach-Object {
    if ($_.Vendor -eq "Standard") {
        New-NpsRadiusClient -Name $_.Name -Address $_.Address -SharedSecret $_.SharedSecret
    } else {
        New-NpsRadiusClient -Name $_.Name -Address $_.Address -SharedSecret $_.SharedSecret -VendorName $_.Vendor
    }
}