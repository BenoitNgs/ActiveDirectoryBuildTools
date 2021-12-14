Import-Module DnsServer

$NetworkScope = "172.20.122.0"
$NetworkMask = "24"
$ReplicationScope = "Forest"
$DynamicUpdate = "NonsecureAndSecure"
$Aging = $True
$AgingRefreshInterval = "30.00:00:00"
$AgingNoRefreshInterval = "30.00:00:00"



function Add-AddCfgDnsZoneRevers{
    param(
        [Parameter(Mandatory=$true)][string]$NetworkScope,
        [Parameter(Mandatory=$true)][string]$NetworkMask = "24",
        [Parameter(Mandatory=$true)][string]$ReplicationScope = "Domain",
        [Parameter(Mandatory=$true)][string]$DynamicUpdate = "Secure",
        [Parameter(Mandatory=$true)][boolean]$Aging = $false,
        [Parameter(Mandatory=$true)][string]$AgingRefreshInterval = "7.00:00:00",
        [Parameter(Mandatory=$true)][string]$AgingNoRefreshInterval = "7.00:00:00"
    )

    $NetworkID = $NetworkScope +'/' + $NetworkMask
    $Name = $NetworkScope.split('.')[2] + '.' + $NetworkScope.split('.')[1] + '.' + $NetworkScope.split('.')[0] + '.in-addr.arpa'


    if(!$(Get-DnsServerZone -Name $Name)){
        Add-DnsServerPrimaryZone -NetworkId $NetworkID -ReplicationScope $ReplicationScope -DynamicUpdate $DynamicUpdate -PassThru
    }

    Set-DnsServerZoneAging -Name $Name -Aging $Aging -PassThru -Verbose -RefreshInterval $AgingRefreshInterval -NoRefreshInterval $AgingNoRefreshInterval

    $resCfgDnsServerZone = Get-DnsServerZone -Name $Name | Select-Object ZoneName,ReplicationScope,DynamicUpdate
    $resCfgDnsServerZoneAging = Get-DnsServerZoneAging -Name $Name | Select-Object ZoneName,AgingEnabled,RefreshInterval,NoRefreshInterval


    if($resCfgDnsServerZone.ReplicationScope -ne $ReplicationScope){Write-Error "Miss config: ReplicationScope"}else{Write-Warning "OK"}
    if($resCfgDnsServerZone.DynamicUpdate -ne $DynamicUpdate){Write-Error "Miss config: DynamicUpdate"}else{Write-Warning "OK"}
    if($resCfgDnsServerZoneAging.AgingEnabled -ne $Aging){Write-Error "Miss config: AgingEnabled"}else{Write-Warning "OK"}
    if($resCfgDnsServerZoneAging.RefreshInterval -ne $AgingRefreshInterval){Write-Error "Miss config: RefreshInterval"}else{Write-Warning "OK"}
    if($resCfgDnsServerZoneAging.NoRefreshInterval -ne $AgingNoRefreshInterval){Write-Error "Miss config: NoRefreshInterval"}else{Write-Warning "OK"}
}

foreach($Subnet in $(Split-IPv4Subnet -IPv4Address 172.20.122.0 -CIDR 20 -NewCIDR 24)){
    $Subnet.NetworkID.IPAddressToString

    Add-AddCfgDnsZoneRevers -NetworkScope $Subnet.NetworkID.IPAddressToString -NetworkMask "24" -ReplicationScope $ReplicationScope -DynamicUpdate $DynamicUpdate -Aging $Aging -AgingRefreshInterval $AgingRefreshInterval -AgingNoRefreshInterval $AgingNoRefreshInterval

}