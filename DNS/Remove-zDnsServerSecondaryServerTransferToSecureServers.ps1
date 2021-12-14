Import-Module DnsServer

function Remove-zDnsServerSecondaryServerTransferToSecureServers {
    param(
        [Parameter(Mandatory = $true)][string]$ZoneName,
        [Parameter(Mandatory = $true)][string]$IPAddressSecondaryServer,
        [Parameter(Mandatory = $false)][string]$DNSPrimaryServer="localhost"
    )

    $DNSZone = Get-DnsServerZone -ComputerName $DNSPrimaryServer -Name $ZoneName
    $lstDNSZoneSecondaryDnsServer = $DNSZone.SecondaryServers.IPAddressToString
    $lstSecondaryDnsServer = @()

    if($IPAddressSecondaryServer -eq "*"){
        foreach($DNSZoneSecondaryDnsServer in $lstDNSZoneSecondaryDnsServer){
            Set-DnsServerPrimaryZone -ComputerName $DNSPrimaryServer -Name $DNSZone.ZoneName -Notify NoNotify -SecureSecondaries NoTransfer
        }
    }else{
        foreach($DNSZoneSecondaryDnsServer in $lstDNSZoneSecondaryDnsServer){
            if($DNSZoneSecondaryDnsServer -ne $IPAddressSecondaryServer){$lstSecondaryDnsServer += $DNSZoneSecondaryDnsServer}
        } 
    
    Set-DnsServerPrimaryZone -ComputerName $DNSPrimaryServer -Name $DNSZone.ZoneName -Notify Notifyservers -notifyservers $lstSecondaryDnsServer -SecondaryServers $lstSecondaryDnsServer -SecureSecondaries TransferToSecureServers
    }

    return $(Get-DnsServerZone -ComputerName $DNSPrimaryServer -Name $DNSZone.ZoneName | Select-Object ZoneName,SecondaryServers,NotifyServers)
}

Remove-zDnsServerSecondaryServerTransferToSecureServers -ZoneName "teddycorp.lan" -IPAddressSecondaryServer "192.168.1.20"