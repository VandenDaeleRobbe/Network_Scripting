#
# Read CSV file
#
$FILE = Import-Csv -Path "C:\Users\Administrator\Desktop\Network Scripting\Network_Scripting\Docs\Groups.csv" -Delimiter ";"
$FILE | Format-Table


#
# Create group for each line
#
$FILE | ForEach-Object {
    New-ADGroup -Name $_.Name -Path $_.Path -DisplayName $_.DisplayName -Description $_.Description -GroupCategory $_.GroupCategory -GroupScope $_.GroupScope
}