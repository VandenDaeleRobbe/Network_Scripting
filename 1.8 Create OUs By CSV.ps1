#
# Read CSV file
#
$FILE = Import-Csv -Path "C:\Users\Administrator\Desktop\Network Scripting\Network_Scripting\Docs\OUs.csv" -Delimiter ";"


#
# Create OU for each line
#
$FILE | ForEach-Object {
    New-ADOrganizationalUnit -Name $_.Name -Path $_.Path -DisplayName $_.Display_Name -Description $_Description
}