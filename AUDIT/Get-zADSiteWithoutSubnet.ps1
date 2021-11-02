Import-Module ActiveDirectory

function Get-zADSiteWithoutSubnet {
    $lstADSitesSubnet = Get-ADReplicationSubnet -Filter *
    $lstADSites = Get-ADReplicationSite -Filter *
    $res = @()

    foreach($ADSites in $lstADSites){
        if($($lstADSitesSubnet | Where-Object{$_.Site -eq $ADSites.DistinguishedName}).count -eq 0){
            $objSite = New-Object PSObject
            $objSite | Add-Member -name ‘SiteName’ -MemberType NoteProperty -Value $ADSites.Name
            $objSite | Add-Member -name ‘DistinguishedName’ -MemberType NoteProperty -Value $ADSites.DistinguishedName
            $res+=$objSite  
        }
    }
    return $res
}

Get-zADSiteWithoutSubnet