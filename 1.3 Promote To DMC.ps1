#Install Windows feature Active Directory Domain Services
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

#Promote server to domain controller
Install-ADDSForest -DomainName "intranet.mijnschool.be" -DomainNetbiosName "MIJNSCHOOLBE" -InstallDNS
