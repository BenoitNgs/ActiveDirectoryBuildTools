Import-Module ActiveDirectory

function Get-zADReplicationSiteLinkDistribute {
    $res = @()
    $lstADSitesLink = Get-ADReplicationSiteLink -Filter *

    foreach($ADSitesLink in $lstADSitesLink){

        if($ADSitesLink.SitesIncluded.count -eq 1){Write-Warning $ADSitesLink.Name}
        elseif($ADSitesLink.SitesIncluded.count -eq 1){
                $objSite = New-Object PSObject
                $objSite | Add-Member -name ‘SiteLinkName’ -MemberType NoteProperty -Value $ADSitesLink.Name
                $objSite | Add-Member -name ‘SiteLinkCost’ -MemberType NoteProperty -Value $ADSitesLink.Cost
                $objSite | Add-Member -name ‘SiteLinkFreqMnts’ -MemberType NoteProperty -Value $ADSitesLink.ReplicationFrequencyInMinutes
                $objSite | Add-Member -name ‘Site1’ -MemberType NoteProperty -Value $ADSitesLink.SitesIncluded[0].split(",").Split("=")[1]
                $objSite | Add-Member -name ‘Site2’ -MemberType NoteProperty -Value "Orphane site"

                $res+=$objSite           
        }else{
            For($i = 0; $i -lt $ADSitesLink.SitesIncluded.count; $i++){
                For($j = $($i+1); $j -lt $ADSitesLink.SitesIncluded.count; $j++){
                    $objSite = New-Object PSObject
                    $objSite | Add-Member -name ‘SiteLinkName’ -MemberType NoteProperty -Value $ADSitesLink.Name
                    $objSite | Add-Member -name ‘SiteLinkCost’ -MemberType NoteProperty -Value $ADSitesLink.Cost
                    $objSite | Add-Member -name ‘SiteLinkFreqMnts’ -MemberType NoteProperty -Value $ADSitesLink.ReplicationFrequencyInMinutes
                    $objSite | Add-Member -name ‘Site1’ -MemberType NoteProperty -Value $ADSitesLink.SitesIncluded[$i].split(",").Split("=")[1]
                    $objSite | Add-Member -name ‘Site2’ -MemberType NoteProperty -Value $ADSitesLink.SitesIncluded[$j].split(",").Split("=")[1]

                    $res+=$objSite

                }
            }
        }
    }
    return $res
}

Get-zADReplicationSiteLinkDistribute