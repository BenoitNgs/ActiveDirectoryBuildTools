$LogsRAW4624 = ""
$LogsRAW3000 = ""
$LogClear4624 = @()
$LogClear3000 = @()
#$LogsRAW3000 = Get-WinEvent -FilterHashtable @{LogName = 'ForwardedEvents'; ID = 3000 }
#$LogsRAW4624 = Get-WinEvent -FilterHashtable @{LogName = 'ForwardedEvents'; ID = 4624; Data = "NTLM V1" }
$LogRepo = "E:\Logs"
$resRepo = "E:\Logs\Results"
$archives4624repo = "E:\Logs\Archives\4624"


$lstLogFiles4624 = Get-ChildItem $LogRepo | Where-Object{$_.Name -like "Archive-ForwardedEvents-*"}

foreach($LogFiles4624 in $lstLogFiles4624){

    $LogFiles4624.FullName
    $(get-date).ToString('yyyyMMdd-HHmmss')
    $LogsRAW4624 = ""
    $LogsRAW4624 = Get-WinEvent -FilterHashtable @{path = $($LogFiles4624.FullName);LogName = 'ForwardedEvents'; ID = 4624; Data = "NTLM V1"} | Select-Object *
    #$LogsRAW4624 = Get-WinEvent -FilterHashtable @{path = $("E:\Logs\ForwardedEvents.evtx");LogName = 'ForwardedEvents'; ID = 4624; Data = "NTLM V1"} | Select-Object *

    foreach($log in $LogsRAW4624){

        $objLog = New-Object System.object
        $objLog | Add-Member -name ‘TimeCreated’ -MemberType NoteProperty -Value $log.TimeCreated
        $objLog | Add-Member -name ‘WorkstationName’ -MemberType NoteProperty -Value $log.Properties[11].Value
        $objLog | Add-Member -name ‘Account’ -MemberType NoteProperty -Value $($log.Properties[6].Value + "\" + $log.Properties[5].Value)
        $objLog | Add-Member -name ‘IPAddress’ -MemberType NoteProperty -Value $log.Properties[18].Value
        $objLog | Add-Member -name ‘NTLM’ -MemberType NoteProperty -Value $log.Properties[14].Value
        $objLog | Add-Member -name ‘DC’ -MemberType NoteProperty -Value $log.MachineName

        $LogClear4624+=$objLog
    }
    Move-Item $($LogFiles4624.FullName) $archives4624repo
    $(get-date).ToString('yyyyMMdd-HHmmss')
}

$LogClear4624 | export-csv -Path "$resRepo\glb.ntlm_$($(get-date).ToString('yyyyMMdd-HHmmss')).csv" -NoTypeInformation -Encoding UTF8





############################################################################

$lstLogFiles4624 = Get-ChildItem $LogRepo | Where-Object{$_.Name -like "Archive-ForwardedEvents-*"}

foreach($LogFiles4624 in $lstLogFiles4624){

    $LogFiles4624.FullName
    $(get-date).ToString('yyyyMMdd-HHmmss')
    $LogsRAW4624 = ""
    $LogsRAW4624 = Get-WinEvent -FilterHashtable @{path = $($LogFiles4624.FullName);LogName = 'ForwardedEvents'; ID = 8002} | Select-Object *

    foreach($log in $LogsRAW4624){

        $objLog = New-Object System.object
        $objLog | Add-Member -name ‘TimeCreated’ -MemberType NoteProperty -Value $log.TimeCreated
        $objLog | Add-Member -name ‘WorkstationName’ -MemberType NoteProperty -Value $log.Properties[11].Value
        $objLog | Add-Member -name ‘Account’ -MemberType NoteProperty -Value $($log.Properties[6].Value + "\" + $log.Properties[5].Value)
        $objLog | Add-Member -name ‘IPAddress’ -MemberType NoteProperty -Value $log.Properties[18].Value
        $objLog | Add-Member -name ‘NTLM’ -MemberType NoteProperty -Value $log.Properties[14].Value
        $objLog | Add-Member -name ‘DC’ -MemberType NoteProperty -Value $log.MachineName

        $LogClear4624+=$objLog
    }
    Move-Item $($LogFiles4624.FullName) $archives4624repo
    $(get-date).ToString('yyyyMMdd-HHmmss')
}

$LogClear4624 | export-csv -Path "$resRepo\8002.ntlm_$($(get-date).ToString('yyyyMMdd-HHmmss')).csv" -NoTypeInformation -Encoding UTF8



############################################################################

$LogsRAW4624 = Get-WinEvent -FilterHashtable @{path = 'E:\Logs\Archive-ForwardedEvents-2022-04-07-15-05-57-846.evtx';LogName = 'ForwardedEvents'; ID = 4624; Data = "NTLM V1"} | Select-Object *






$(get-date).ToString('yyyyMMdd-HHmmss')

foreach($log in $LogsRAW4624){

    $objLog = New-Object System.object
    $objLog | Add-Member -name ‘TimeCreated’ -MemberType NoteProperty -Value $log.TimeCreated
    $objLog | Add-Member -name ‘WorkstationName’ -MemberType NoteProperty -Value $log.Properties[11].Value
    $objLog | Add-Member -name ‘Account’ -MemberType NoteProperty -Value $($log.Properties[6].Value + "\" + $log.Properties[5].Value)
    $objLog | Add-Member -name ‘IPAddress’ -MemberType NoteProperty -Value $log.Properties[18].Value
    $objLog | Add-Member -name ‘NTLM’ -MemberType NoteProperty -Value $log.Properties[14].Value
    $objLog | Add-Member -name ‘DC’ -MemberType NoteProperty -Value $log.MachineName

    $LogClear4624+=$objLog

}

$LogClear4624 | export-csv -Path ".\Desktop\glb.ntlm_$($(get-date).ToString('yyyyMMdd-HHmmss')).csv" -NoTypeInformation -Encoding UTF8


$(get-date).ToString('yyyyMMdd-HHmmss')


foreach($log in $LogsRAW3000){

    $objLog = New-Object System.object
    $objLog | Add-Member -name ‘TimeCreated’ -MemberType NoteProperty -Value $log.TimeCreated
    $objLog | Add-Member -name ‘ClientSMBv1_IP’ -MemberType NoteProperty -Value $log.Properties[0].Value
    $objLog | Add-Member -name ‘ServerSMBv1_Name’ -MemberType NoteProperty -Value $log.MachineName

    $LogClear3000+=$objLog
}

$LogClear3000 | export-csv -Path ".\Desktop\glb.smbv1_$($(get-date).ToString('yyyyMMdd-HHmmss')).csv" -NoTypeInformation -Encoding UTF8




<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[(EventID=4624 or EventID=8002)]]</Select>
    <Select Path="Microsoft-Windows-NTLM/Operational">*[System[(EventID=4624 or EventID=8002)]]</Select>
    <Select Path="Microsoft-Windows-SMBServer/Audit">*[System[(EventID=4624 or EventID=8002)]]</Select>
  </Query>
</QueryList>
