$param = @{
    Name = "PSO for users"
    ComplexityEnabled = $true
    Description = "PSO for Standard users"
    LockoutDuration = "00:15:00"
    LockoutObservationWindow = "00:15:00"
    LockoutThreshold = "30"
    MaxPasswordAge = "90.00:00:00"
    MinPasswordAge = "1.00:00:00"
    MinPasswordLength = "12"
    PasswordHistoryCount = "24"
    Precedence = "500"
    ReversibleEncryptionEnabled = $false
}

function Set-PSOCreateAndUpdate{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,HelpMessage = 'The name of PSO.')][string]$Name,
        [Parameter(Mandatory = $true,HelpMessage = 'The name of PSO.')][bool]$ComplexityEnabled,
        [Parameter(Mandatory = $true,HelpMessage = 'The name of PSO.')][string]$Description,
        [Parameter(Mandatory = $true,HelpMessage = 'The name of PSO.')][string]$LockoutDuration,
        [Parameter(Mandatory = $true,HelpMessage = 'The name of PSO.')][string]$LockoutObservationWindow,
        [Parameter(Mandatory = $true,HelpMessage = 'The name of PSO.')][string]$LockoutThreshold,
        [Parameter(Mandatory = $true,HelpMessage = 'The name of PSO.')][string]$MaxPasswordAge,
        [Parameter(Mandatory = $true,HelpMessage = 'The name of PSO.')][string]$MinPasswordAge,
        [Parameter(Mandatory = $true,HelpMessage = 'The name of PSO.')][string]$MinPasswordLength,
        [Parameter(Mandatory = $true,HelpMessage = 'The name of PSO.')][string]$PasswordHistoryCount,
        [Parameter(Mandatory = $true,HelpMessage = 'The name of PSO.')][string]$Precedence,
        [Parameter(Mandatory = $true,HelpMessage = 'The name of PSO.')][bool]$ReversibleEncryptionEnabled
    )

    $objPSO = ""
    $objPSO = Get-ADFineGrainedPasswordPolicy -Filter * | Where-Object{$_.name -eq $Name}

    if(!$objPSO){
        Write-Output "Create PSO"

        $PSOSettings = @{
            Name = $Name
            ComplexityEnabled = $ComplexityEnabled
            Description = $Description
            LockoutDuration = $LockoutDuration
            LockoutObservationWindow = $LockoutObservationWindow
            LockoutThreshold = $LockoutThreshold
            MaxPasswordAge = $MaxPasswordAge
            MinPasswordAge = $MinPasswordAge
            MinPasswordLength = $MinPasswordLength
            PasswordHistoryCount = $PasswordHistoryCount
            Precedence = $Precedence
            ReversibleEncryptionEnabled = $ReversibleEncryptionEnabled
        }

        New-ADFineGrainedPasswordPolicy @PSOSettings

        Start-Sleep 2

        $objPSO = Get-ADFineGrainedPasswordPolicy -Identity $PSOSettings.Name
    }else{
        Write-Output "Update PSO"
        if($objPSO.ComplexityEnabled -ne $ComplexityEnabled){Write-Output "Set ComplexityEnabled"; Set-ADFineGrainedPasswordPolicy -Identity $objPSO.Name -ComplexityEnabled $ComplexityEnabled}
        if($objPSO.Description -ne $Description){Write-Output "Set Description"; Set-ADFineGrainedPasswordPolicy -Identity $objPSO.Name -Description $Description}
        if($objPSO.LockoutDuration -ne $LockoutDuration){Write-Output "Set LockoutDuration"; Set-ADFineGrainedPasswordPolicy -Identity $objPSO.Name -LockoutDuration $LockoutDuration}
        if($objPSO.LockoutObservationWindow -ne $LockoutObservationWindow){Write-Output "Set LockoutObservationWindow"; Set-ADFineGrainedPasswordPolicy -Identity $objPSO.Name -LockoutObservationWindow $LockoutObservationWindow}
        if($objPSO.LockoutObservationWindow -ne $LockoutThreshold){Write-Output "Set LockoutThreshold"; Set-ADFineGrainedPasswordPolicy -Identity $objPSO.Name -LockoutThreshold $LockoutThreshold}
        if($objPSO.LockoutObservationWindow -ne $MaxPasswordAge){Write-Output "Set MaxPasswordAge"; Set-ADFineGrainedPasswordPolicy -Identity $objPSO.Name -MaxPasswordAge $MaxPasswordAge}
        if($objPSO.LockoutObservationWindow -ne $MinPasswordAge){Write-Output "Set MinPasswordAge"; Set-ADFineGrainedPasswordPolicy -Identity $objPSO.Name -MinPasswordAge $MinPasswordAge}
        if($objPSO.LockoutObservationWindow -ne $MinPasswordLength){Write-Output "Set MinPasswordLength"; Set-ADFineGrainedPasswordPolicy -Identity $objPSO.Name -MinPasswordLength $MinPasswordLength}
        if($objPSO.LockoutObservationWindow -ne $PasswordHistoryCount){Write-Output "Set PasswordHistoryCount"; Set-ADFineGrainedPasswordPolicy -Identity $objPSO.Name -PasswordHistoryCount $PasswordHistoryCount}
        if($objPSO.LockoutObservationWindow -ne $Precedence){Write-Output "Set Precedence"; Set-ADFineGrainedPasswordPolicy -Identity $objPSO.Name -Precedence $Precedence}
        if($objPSO.LockoutObservationWindow -ne $ReversibleEncryptionEnabled){Write-Output "Set ReversibleEncryptionEnabled"; Set-ADFineGrainedPasswordPolicy -Identity $objPSO.Name -ReversibleEncryptionEnabled $ReversibleEncryptionEnabled}
    }
    
    Set-ADObject -Identity $objPSO.DistinguishedName -ProtectedFromAccidentalDeletion:$true
}

Set-PSOCreateAndUpdate @param