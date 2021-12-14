Import-Module DnsServer

function Add-zDnsServerSecondaryServerTransferToSecureServers {
    param(
        [Parameter(Mandatory = $true)][string]$ZoneName,
        [Parameter(Mandatory = $true)][array]$IPAddressSecondaryServer,
        [Parameter(Mandatory = $false)][string]$DNSPrimaryServer="localhost"
    )

    $DNSZone = Get-DnsServerZone -ComputerName $DNSPrimaryServer -Name $ZoneName | Select-Object *
    $lstSecondaryDnsServer = @()
    
    ForEach($IPAddress in $IPAddressSecondaryServer){
        $objSecondaryDNSServer = New-Object System.object
        $objSecondaryDNSServer | Add-Member -name 'IPAddressSecondaryServer' -MemberType NoteProperty -Value $IPAddress
        $lstSecondaryDnsServer += $objSecondaryDNSServer.IPAddressSecondaryServer
    }

    ForEach($IPAddress in $DNSZone.SecondaryServers.IPAddressToString){
        $objSecondaryDNSServer = New-Object System.object
        $objSecondaryDNSServer | Add-Member -name 'IPAddressSecondaryServer' -MemberType NoteProperty -Value $IPAddress
        $lstSecondaryDnsServer += $objSecondaryDNSServer.IPAddressSecondaryServer
    }

    $lstSecondaryDnsServer = $lstSecondaryDnsServer | Select-Object -Unique

    Set-DnsServerPrimaryZone -ComputerName $DNSPrimaryServer -Name $DNSZone.ZoneName -Notify Notifyservers -notifyservers $lstSecondaryDnsServer -SecondaryServers $lstSecondaryDnsServer -SecureSecondaries TransferToSecureServers

    return $(Get-DnsServerZone -ComputerName $DNSPrimaryServer -Name $DNSZone.ZoneName | Select-Object ZoneName,SecondaryServers,NotifyServers)
}

Add-zDnsServerSecondaryServerTransferToSecureServers -ZoneName "teddycorp.lan" -IPAddressSecondaryServer "192.168.1.20"