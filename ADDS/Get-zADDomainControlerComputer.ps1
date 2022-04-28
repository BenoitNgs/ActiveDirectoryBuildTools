function Get-zADDomainControlerComputer{
    $lstDC = @()
    foreach($ADDomain in $(Get-ADForest).Domains){
        $lstDC += $(Get-ADDomain -server:$ADDomain).ReadOnlyReplicaDirectoryServers
        $lstDC += $(Get-ADDomain -server:$ADDomain).replicadirectoryservers
    }

    $res = @()
    foreach($dc in $lstDC){
        $dom = $dc.Substring($($($dc.Split('.')[0]).Length + 1),$($($dc.Length) - $($dc.Split('.')[0]).Length - 1))
        $cpt = $dc.Split('.')[0]
        $pdc = $(Get-ADDomain -Identity $dom | Select-Object -Property PDCEmulator).PDCEmulator

        $res += Get-ADComputer -Identity $cpt -Server $pdc -Properties * | Select-Object *
    }
    return $res
}


Get-zADDomainControlerComputer
