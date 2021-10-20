#Build new AD Forest
#Install DNS role in same time

$param = @{
    CreateDnsDelegation = $false
    ForestMode = 'WinThreshold'
    DomainMode = 'WinThreshold'
    DomainName = 'teddy.lab'
    DomainNetbiosName = 'TEDDY'
    InstallDns = $true
    DatabasePath = 'C:\Windows\NTDS'
    LogPath = 'C:\Windows\NTDS'
    SysvolPath = 'C:\Windows\SYSVOL'
    NoRebootOnCompletion = $false
    Force = $true
    SafeModeAdministratorPassword = ConvertTo-SecureString "ToBeReadInKeyVault-123" -AsPlainText -Force
}

Install-WindowsFeature -Name AD-Domain-Services

Import-Module ADDSDeployment

Install-ADDSForest @param
