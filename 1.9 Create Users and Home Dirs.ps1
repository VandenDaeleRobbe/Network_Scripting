#
# Read CSV file
#
$FILE = Import-Csv -Path "C:\Users\Administrator\Desktop\Network Scripting\Network_Scripting\Docs\UserAccounts.csv" -Delimiter ";"
$FILE | Format-Table

#
# Create user account for each line
#
$FILE | ForEach-Object {
    # Create user
    $secure_password = ConvertTo-SecureString $_.AccountPassword -AsPlainText -Force
    [System.Boolean] $bool = 1
    New-ADUser -Name $_.Name -SamAccountName $_.SamAccountName -GivenName $_.GivenName -Surname $_.Surname -DisplayName $_.DisplayName -AccountPassword $secure_password -HomeDrive $_.HomeDrive -HomeDirectory $_.HomeDirectory -Enabled $bool

    # Create home dir
    $acc_name = $_.SamAccountName
    $home_path = "\\win13-ms\homes\$acc_name"
    $home_share = New-Item -Path $home_path -ItemType Directory -Force
    $acl = Get-Acl $home_path
    $ar1 = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrator", "FullControl", "None", "None", "Allow")
    $ar2 = New-Object System.Security.AccessControl.FileSystemAccessRule($_.SamAccountName, "Modify", "None", "None", "Allow")
    $acl.SetAccessRule($ar1)
    $acl.SetAccessRule($ar2)
    Set-Acl $home_path $acl
}
