# Get powershell module
Get-Command -Module NTFSSecurity

# Variables
$domain = Get-ADDomain
$netbiosname = $domain.NetBIOSName
$remote_pc = Read-Host "Enter the computer name to make a homes share on"
$dir_remote = "\\$remote_pc\c$\homes"
$dir_local = "c:\homes"
$share_name = "homes"

# Create home folder and share it
$session = New-CimSession -ComputerName $remote_pc # Create CIM session
New-Item "$dir_remote" -ItemType Dir # Create normal folder
New-SMBShare -Name "$share_name" -Path "$dir_local" -CimSession $session # Make folder a SMB share

# Set share and NTFS permissions
Grant-SmbShareAccess -Name $share_name -AccountName "Everyone" -AccessRight Full -CimSession $session -Force
$acl = Get-Acl $dir_remote
$ar = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrator", "FullControl", "None", "None", "Allow")
$ar1 = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users", "FullControl", "None", "None", "Allow")
$acl.SetAccessRule($ar)
$acl.SetAccessRule($ar1)
Set-Acl $dir_remote $acl

