Import-Module ActiveDirectory


Get-KdsRootKey
#Check if necessary ?
Add-KdsRootKey -EffectiveTime ((Get-Date).AddHours(-10))
Get-KdsRootKey


$Param = @{
    Name = 'gMSA-AADC01'
    Description = 'Service account for AADC'
    DNSHostName = 'gMSA-AADC01.teddy.lan'
    PrincipalsAllowedToRetrieveManagedPassword = 'AADC01$'
}

New-ADServiceAccount @Param  -PassThru

Get-ADServiceAccount -Identity $Param.Name -Properties *