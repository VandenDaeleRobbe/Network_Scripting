#
# Variables
#
$profile_path = "\\win13-DC2\profiles\%username%"
$public_dir = "\\win13-DC2\c$\desktops"
$share_name = "Desktops"
$local_dir = "c:\desktops"

#
# Create profile path for all users in secretariaat
#
Get-ADGroupMember -Identity "secretariaat" | ForEach-Object {
    $acc_name = $_.SamAccountName
    Set-ADUser -Identity $acc_name -ProfilePath $profile_path
}

#
# Create session with DC2
#
$cred = Get-Credential -Message "Credentials of server to configure"
$session = New-PSSession -Credential $cred -ComputerName "win13-DC2"

#
# Create folder 
#
Invoke-Command -Session $session {
    New-Item $using:public_dir -ItemType Dir
    $new_folder = Get-Item $using:public_dir

    New-SMBShare -Name "$using:share_name" -Path "$using:local_dir"
    Grant-SmbShareAccess -Name $using:share_name -AccountName "Everyone" -AccessRight Full -Force

    $acl = Get-Acl $using:public_dir
    $ar1 = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
    $ar2 = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users", "Read", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($ar1)
    $acl.AddAccessRule($ar2)
    Set-Acl $using:public_dir $acl
}