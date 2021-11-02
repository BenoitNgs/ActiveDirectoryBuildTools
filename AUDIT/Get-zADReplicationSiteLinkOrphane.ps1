Import-Module ActiveDirectory

function Get-zADReplicationSiteLinkOrphane {
    $res = @()
    $lstADSitesLink = Get-ADReplicationSiteLink -Filter *

    foreach($ADSitesLink in $lstADSitesLink){
        if($ADSitesLink.SitesIncluded.count -eq 1){
            $objSite = New-Object PSObject
            $objSite | Add-Member -name ‘SiteLinkName’ -MemberType NoteProperty -Value $ADSitesLink.Name
            $objSite | Add-Member -name ‘SiteLinkDistinguishedName’ -MemberType NoteProperty -Value $ADSitesLink.DistinguishedName
            $objSite | Add-Member -name ‘SiteLinkObjectGUID’ -MemberType NoteProperty -Value $ADSitesLink.ObjectGUID
            $objSite | Add-Member -name ‘SiteLinkCost’ -MemberType NoteProperty -Value $ADSitesLink.Cost
            $objSite | Add-Member -name ‘SiteLinkFreqMnts’ -MemberType NoteProperty -Value $ADSitesLink.ReplicationFrequencyInMinutes

            $res+=$objSite
        }
    }
    return $res
}


Get-zADReplicationSiteLinkOrphane