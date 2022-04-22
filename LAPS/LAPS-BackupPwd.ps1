Import-Module ActiveDirectory

$exportFileName = "LAPSBackup_$($(get-date).ToString('yyyyMMdd-HHmmss')).csv"
$exportFilePath = "c:\temp\"
$exportFileFull = $exportFilePath+$exportFileName
$lstADDomain = @()
$lstADCpt = @()
$res = @()

if (!$(Test-Path -Path $exportFilePath)){New-Item -ItemType "directory" -Path $exportFilePath}

$lstADDomain += $(Get-ADDomain).Forest
$lstADDomain += $(Get-ADDomain).ChildDomains

foreach($ADDomain in $lstADDomain){
    Write-Output "List computers in: $ADDomain"
    $lstADCpt += Get-ADComputer -filter * -Properties Name, DNSHostName, ms-Mcs-AdmPwd, mS-MCS-AdmPwdExpirationTime, DistinguishedName -Server $ADDomain | select Name, DNSHostName, ms-Mcs-AdmPwd, mS-MCS-AdmPwdExpirationTime, DistinguishedName
}

foreach($ADCpt in $lstADCpt){
    $objCPT = New-Object System.object
    $objCPT | Add-Member -name "Name" -MemberType NoteProperty -Value $ADCpt.Name
    $objCPT | Add-Member -name "DNSHostName" -MemberType NoteProperty -Value $ADCpt.DNSHostName

    if([string]::IsNullOrEmpty($ADCpt."ms-Mcs-AdmPwd")){$objCPT | Add-Member -name "ms-Mcs-AdmPwd" -MemberType NoteProperty -Value "No LPAS PWD"}else{$objCPT | Add-Member -name "ms-Mcs-AdmPwd" -MemberType NoteProperty -Value $ADCpt."ms-Mcs-AdmPwd"}

    if([string]::IsNullOrEmpty($ADCpt."mS-MCS-AdmPwdExpirationTime")){
        $objCPT | Add-Member -name "mS-MCS-AdmPwdExpirationTime" -MemberType NoteProperty -Value "No expiration date"
    }else{
        $objCPT | Add-Member -name "mS-MCS-AdmPwdExpirationTime" -MemberType NoteProperty -Value $(Get-Date([datetime]::FromFileTime($ADCpt."mS-MCS-AdmPwdExpirationTime")) -Format "yyyyMMdd-HHmmss")
    }
    $objCPT | Add-Member -name "DistinguishedName" -MemberType NoteProperty -Value $ADCpt.DistinguishedName

    $res += $objCPT
}

$res | Export-Csv -Path $exportFileFull -NoTypeInformation -Encoding UTF8
