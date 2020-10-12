#
# Read CSV file
#
$FILE = Import-Csv -Path "C:\Users\Administrator\Desktop\Network Scripting\Network_Scripting\Docs\GroupMembers.csv" -Delimiter ";"
$FILE | Format-Table


#
# Add user to group for each line
#
$FILE | ForEach-Object {
    Add-ADGroupMember -Identity $_.Identity -Members $_.Member
}