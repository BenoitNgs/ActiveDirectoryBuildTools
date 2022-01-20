#Add new AD Forest
#Install DNS role in same time

$param = @{
    NoGlobalCatalog = $false
    CreateDnsDelegation = $false
    CriticalReplicationOnly = $false
    InstallDns = $true
    NoRebootOnCompletion = $false
    DomainName = "teddy.lab"
    DatabasePath = "C:\Windows\NTDS"
    LogPath = "C:\Windows\NTDS"
    SiteName = "ADSite"
    SysvolPath = "C:\Windows\SYSVOL"
    Force = $true
    SafeModeAdministratorPassword = ConvertTo-SecureString "ToBeReadInKeyVault-123" -AsPlainText -Force
}


Install-WindowsFeature -Name AD-Domain-Services

Import-Module ADDSDeployment

Install-ADDSDomainController @param