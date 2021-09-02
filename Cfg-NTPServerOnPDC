$GPOBackupPath = "C:\Users\Administrator\Desktop\Cfg-NTPServerOnPDC"
$GPOName = "Cfg-NTPServerOnPDC"

New-GPO -Name $GPOName


function Import-zGPO{
    param(
        [Parameter(Mandatory=$true)][string]$GPOBackupPath,
        [Parameter(Mandatory=$true)][string]$GPOName,
        [Parameter(Mandatory=$true)][string]$Force
    )
    Import-Module -Name GroupPolicy


    #Case of GPO already exist, switch $force delete or no GPO.
    if($(Get-GPO -All | where{$_.DisplayName -eq $GPOName})){
        Write-Warning "GPO here"

        if($Force -eq $false){
            Write-Error "GPO already exist: $GPOName"
            return $false
        }else{
            Remove-GPO -Name $GPOName
            Start-Sleep 1
            if($(Get-GPO -All | where{$_.DisplayName -eq $GPOName})){Write-Error "GPO already exist and can't be delete: $GPOName"; return $false}
        }
    }

    #Create and import GPO:
    $NewGPOToBeImported = New-GPO -Name $GPOName
    Start-Sleep 1
    if(!$(Import-GPO -Path $GPOBackupPath -BackupId $(Get-ChildItem -Path $GPOBackupPath -Attributes Directory).name -TargetName $NewGPOToBeImported.DisplayName)){Write-Error "GPO import failed: $($error[0])";return $false}

    if($(Get-GPO -All | where{$_.DisplayName -eq $GPOName})){
        return $(Get-GPO -Name $GPOName)
    }else{return $false}

    return $false
}

Import-zGPO -GPOBackupPath $GPOBackupPath -GPOName $GPOName -Force $true
