$WMIFilters = @{
    Name = 'Target-PDCEmulator'
    Query = 'Select * From Win32_ComputerSystem where DomainRole=5'
    Description = 'Apply on the domaine controler with PDC FSMO role'
}

$defaultNamingContext = (get-adrootdse).defaultnamingcontext
$addsWMIFilterBaseDN = "CN=SOM,CN=WMIPolicy,CN=System,$defaultNamingContext"


if($(Get-ADObject -SearchBase $addsWMIFilterBaseDN -LDAPFilter "(objectClass=msWMI-Som)" -Properties msWMI-Name | Where-Object {$_."msWMI-Name" -eq $WMIFilters.Name})){
    Write-Output "WMI filter named: $($WMIFilters.Name) already exist, to limit the impact of miss config, no action will be realised"; return $false
}


$newWMIFilterGUID = [string]"{"+([System.Guid]::NewGuid())+"}"
$newWMIFilterDN = "CN="+$newWMIFilterGUID+","+$addsWMIFilterBaseDN
$now = (Get-Date).ToUniversalTime()

$param = @{
    name = $newWMIFilterGUID
    type = "msWMI-Som"
    Path = $addsWMIFilterBaseDN
    OtherAttributes = @{
        'msWMI-Name' = $WMIFilters.Name
        'msWMI-Parm1' = $WMIFilters.Description
        'msWMI-Parm2' = $("1;3;10;" + $WMIFilters.Query.Length.ToString() + ";WQL;root\CIMv2;" + $WMIFilters.Query + ";")
        'msWMI-Author' = $($env:UserName + "@" + [System.DirectoryServices.ActiveDirectory.Domain]::getcurrentdomain().name)
        'msWMI-ID' = $newWMIFilterGUID
        'instanceType' = 4
        'showInAdvancedViewOnly' = "TRUE"
        'distinguishedname '= $newWMIFilterDN
        'msWMI-ChangeDate' = $(($now.Year).ToString("0000") + ($now.Month).ToString("00") + ($now.Day).ToString("00") + ($now.Hour).ToString("00") + ($now.Minute).ToString("00") + ($now.Second).ToString("00") + "." + ($now.Millisecond * 1000).ToString("000000") + "-000")
        'msWMI-CreationDate' = $(($now.Year).ToString("0000") + ($now.Month).ToString("00") + ($now.Day).ToString("00") + ($now.Hour).ToString("00") + ($now.Minute).ToString("00") + ($now.Second).ToString("00") + "." + ($now.Millisecond * 1000).ToString("000000") + "-000")
    }
}

New-ADObject @param