function New-zADReplicationSite {
    param(
        [Parameter(Mandatory = $true)][string]$NewSiteName
    )

    Import-Module ActiveDirectory

    if (Get-ADReplicationSite -filter * | Where-Object { $_.Name -eq $NewSiteName}) { Write-Error "AD Site already exist: $NewSiteName"; return $false }

    try {
        New-ADReplicationSite -Name $NewSiteName
    }
    catch {
         Write-Error "AD Site failed to create: $NewSiteName"
         return $false
    }

    Start-Sleep 2

    if (Get-ADReplicationSite -Identity $NewSiteName) {
        Write-Output "New site create: $NewSiteName"
        return Get-ADReplicationSite -Identity $NewSiteName
    }
    else {
        Write-Error "No site created"
        return $false
    }
    return $false
}

New-zADReplicationSite -NewSiteName Azure-WE
