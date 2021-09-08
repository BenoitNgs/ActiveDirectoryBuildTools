$ErrorActionPreference = "stop"

function Set-zADReplicationSiteRename {
    param(
        [Parameter(Mandatory = $true)][string]$Identity,
        [Parameter(Mandatory = $true)][string]$NewName
    )

    Write-Warning $Identity
    Write-Warning $NewName

    Import-Module ActiveDirectory

    if (Get-ADReplicationSite | Where-Object { $_.Name -eq $NewName }) { Write-Error "AD Site already exist: $NewName"; return $false }

    #try {
    #    Get-ADReplicationSite -Identity $Identity
    #}
    #catch {
    #    Write-Error "No AD Site Found: $Identity"
    #    return $false   
    #}

    if (Get-ADReplicationSite | Where-Object { $_.Name -eq $Identity }) {
        Get-ADObject -SearchBase (Get-ADRootDSE).ConfigurationNamingContext -LDAPFilter "(ObjectClass=site)" | Where-Object { $_.name -eq $Identity } | Rename-ADObject -NewName $NewName
    }
    else {
        Write-Error "No AD Site Found: $Identity"
        return $false
    }

    Start-Sleep 2

    if (Get-ADReplicationSite -Identity $NewName) {
        Write-Host "Primary site renamed in $NewName"
        return Get-ADReplicationSite -Identity $NewName
    }
    else {
        Write-Error "No site rename"
        return $false
    }
    return $false
}


$param = @{
    Identity = "Default-First-Site-Name";
    NewName = "AzureStack"
}

Set-zADReplicationSiteRename @param