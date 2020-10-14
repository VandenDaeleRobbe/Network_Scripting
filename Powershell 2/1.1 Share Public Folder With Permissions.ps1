#
# Variables
#
$public_dir = "\\win13-MS\\c$\public"
$share_name = "public"
$local_dir = "c:\public"

#
# Create session with MS
#
$cred = Get-Credential -Message "Credentials of server to configure"
$session = New-PSSession -Credential $cred -ComputerName "win13-MS"

#
# Create public folder and share it
#
Invoke-Command -Session $session {
    New-Item $using:public_dir -ItemType Dir #Create directory
    New-SMBShare -Name "$using:share_name" -Path "$using:local_dir" # Make folder a SMB share

    Grant-SmbShareAccess -Name $using:share_name -AccountName "Everyone" -AccessRight Full -Force
    $acl = Get-Acl $using:public_dir
    $ar2 = New-Object System.Security.AccessControl.FileSystemAccessRule("personeel", "Read", "ContainerInherit, ObjectInherit", "None", "Allow")
    $ar3 = New-Object System.Security.AccessControl.FileSystemAccessRule("personeel", "ReadAndExecute", "ContainerInherit, ObjectInherit", "None", "Allow")
    $ar4 = New-Object System.Security.AccessControl.FileSystemAccessRule("personeel", "Write", "ContainerInherit, ObjectInherit", "None", "Allow")
    $ar1 = New-Object System.Security.AccessControl.FileSystemAccessRule("personeel", "ListDirectory", "ContainerInherit, ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($ar1)
    $acl.AddAccessRule($ar2)
    $acl.AddAccessRule($ar3)
    $acl.AddAccessRule($ar4)
    Set-Acl $using:public_dir $acl
}

#
# Exit session
#
Remove-PSSession $session