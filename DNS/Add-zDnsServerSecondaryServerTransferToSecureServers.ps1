Import-Module DnsServer

function Add-zDnsServerSecondaryServerTransferToSecureServers {
    param(
        [Parameter(Mandatory = $true)][string]$ZoneName,
        [Parameter(Mandatory = $true)][string]$IPAddressSecondaryServer
    )

    $DNSZone = Get-DnsServerZone -Name $ZoneName
    $lstSecondaryDnsServer = $DNSZone.SecondaryServers.IPAddressToString + $IPAddressSecondaryServer
    $lstSecondaryDnsServer = $lstSecondaryDnsServer | Select-Object -Unique
    Set-DnsServerPrimaryZone -Name $DNSZone.ZoneName -Notify Notifyservers -notifyservers $lstSecondaryDnsServer -SecondaryServers $lstSecondaryDnsServer -SecureSecondaries TransferToSecureServers

    return $(Get-DnsServerZone -Name $DNSZone.ZoneName | Select-Object ZoneName,SecondaryServers,NotifyServers)
}

Add-zDnsServerSecondaryServerTransferToSecureServers -ZoneName "teddycorp.lan" -IPAddressSecondaryServer "192.168.1.20"