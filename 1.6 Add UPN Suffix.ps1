# Get Forest and create UPN Suffix
Get-ADForest | Set-ADForest -UPNSuffixes @{add="mijnschool.be"}