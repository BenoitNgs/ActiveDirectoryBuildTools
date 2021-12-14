Import-Module DnsServer

function Remove-zDnsServerSecondaryServerTransferToSecureServers {
    param(
        [Parameter(Mandatory = $true)][string]$ZoneName,
        [Parameter(Mandatory = $true)][string]$IPAddressSecondaryServer
    )

    $DNSZone = Get-DnsServerZone -Name $ZoneName
    $lstDNSZoneSecondaryDnsServer = $DNSZone.SecondaryServers.IPAddressToString | Select-Object -Unique
    $lstSecondaryDnsServer = @()

    foreach($DNSZoneSecondaryDnsServer in $lstDNSZoneSecondaryDnsServer){
        if($DNSZoneSecondaryDnsServer -ne $IPAddressSecondaryServer){$lstSecondaryDnsServer += $DNSZoneSecondaryDnsServer}
    }
    
    Set-DnsServerPrimaryZone -Name $DNSZone.ZoneName -Notify Notifyservers -notifyservers $lstSecondaryDnsServer -SecondaryServers $lstSecondaryDnsServer -SecureSecondaries TransferToSecureServers

    return $(Get-DnsServerZone -Name $DNSZone.ZoneName | Select-Object ZoneName,SecondaryServers,NotifyServers)
}

Remove-zDnsServerSecondaryServerTransferToSecureServers -ZoneName "teddycorp.lan" -IPAddressSecondaryServer "192.168.1.20"