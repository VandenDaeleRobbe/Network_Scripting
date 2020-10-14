#
# Variables
#
$public_dir = "\\win13-DC2\c$\profiles"
$share_name = "profiles"
$local_dir = "c:\profiles"

#
# Create session with DC2
#
$cred = Get-Credential -Message "Credentials of server to configure"
$session = New-PSSession -Credential $cred -ComputerName "win13-DC2"

#
# Create folder and hide it
#
Invoke-Command -Session $session {
    New-Item $using:public_dir -ItemType Dir
    $new_folder = Get-Item $using:public_dir
    $new_folder.Attributes="Hidden"

    New-SMBShare -Name "$using:share_name" -Path "$using:local_dir"
    Grant-SmbShareAccess -Name $using:share_name -AccountName "Everyone" -AccessRight Full -Force

    $acl = Get-Acl $using:public_dir
    $ar1 = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
    $ar2 = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users", "Read", "None", "None", "Allow")
    $acl.AddAccessRule($ar1)
    $acl.AddAccessRule($ar2)
    Set-Acl $using:public_dir $acl
}

#
# Exit session
#
Remove-PSSession $session