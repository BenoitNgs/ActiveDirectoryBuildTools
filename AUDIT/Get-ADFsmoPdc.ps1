Get-ADForest | Select-Object -ExpandProperty RootDomain | Get-ADDomain | Select-Object -Property PDCEmulator
$(Get-ADForest | Select-Object -ExpandProperty RootDomain | Get-ADDomain).ChildDomains | Get-ADDomain | Select-Object -Property PDCEmulator
