$resRepo = "E:\Logs\Results"

$lstGlbDC = @()
$lstDC = @()


$lstGlbDC += $(Get-ADForest | Select-Object -ExpandProperty RootDomain | Get-ADDomain).ReadOnlyReplicaDirectoryServers
$lstGlbDC += $(Get-ADForest | Select-Object -ExpandProperty RootDomain | Get-ADDomain).ReplicaDirectoryServers
$lstGlbDC += $($(Get-ADForest | Select-Object -ExpandProperty RootDomain | Get-ADDomain).ChildDomains | Get-ADDomain).ReadOnlyReplicaDirectoryServers
$lstGlbDC += $($(Get-ADForest | Select-Object -ExpandProperty RootDomain | Get-ADDomain).ChildDomains | Get-ADDomain).ReplicaDirectoryServers


foreach($dc in $lstGlbDC){
    $objDC = New-Object System.object
    $objDC | Add-Member -name ‘DCFQDN’ -MemberType NoteProperty -Value $dc
    $objDC | Add-Member -name ‘DCName’ -MemberType NoteProperty -Value $dc.Split(".")[0]
    $objDC | Add-Member -name ‘DCDomain’ -MemberType NoteProperty -Value $dc.Replace($($dc.Split(".")[0]+"."),"")

    $lstDC += $objDC
}

$lstDC | export-csv -Path "$resRepo\lstDC_$($(get-date).ToString('yyyyMMdd-HHmmss')).csv" -NoTypeInformation -Encoding UTF8
