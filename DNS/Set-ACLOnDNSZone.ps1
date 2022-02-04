$DNSZoneName = "teddycorp.lan"
$UserName = "teddy-operator"

Import-Module DnsServer
Import-Module ActiveDirectory


Set-Location AD:

if(!$(Get-DnsServerZone | Where-Object{$_.ZoneName -eq $DNSZoneName})){
    Write-Output "DNS zone missing: $DNSZoneName"
    #$Ansible.Failed = $true
}else{
    $DNSZoneDN = $(Get-DnsServerZone -Name $DNSZoneName).DistinguishedName
}


if(!$(Get-ADUser -Filter * | Where-Object{$_.Name -eq $UserName})){
    Write-Output "AD user missing: $UserName"
    #$Ansible.Failed = $true
}else{
    $objADUser = Get-ADUser -Identity $UserName
}


$ACL = Get-Acl -Path $(Get-DnsServerZone -Name $DNSZoneName).DistinguishedName

$Identity = [System.Security.Principal.IdentityReference]$objADUser.SID
$ADRight = [System.DirectoryServices.ActiveDirectoryRights] "GenericWrite, GenericRead, CreateChild, DeleteChild, ListChildren, ReadProperty"
$Type = [System.Security.AccessControl.AccessControlType] "Allow"
$InheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "All"
$Rule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($Identity, $ADRight, $Type,  $InheritanceType)

$ACL.AddAccessRule($Rule)
Set-Acl -Path $DNSZoneDN -AclObject $ACL