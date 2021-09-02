#Build new AD Forest
#Install DNS role in same time


$NTDSDBPath = "F:\Windows\NTDS"
$NTDSLogPath = "F:\Windows\NTDS"
$SYSVOLPath = "F:\Windows\SYSVOL"
$DomainName = "teddy.lab"
$NETBIOSName = "TEDDY"
$DSRM = ConvertTo-SecureString "ToBeReadInKeyVault" -AsPlainText -Force

Install-WindowsFeature -Name AD-Domain-Services

Import-Module ADDSDeployment

Install-ADDSForest -CreateDnsDelegation:$false -DomainMode "WinThreshold" -ForestMode "WinThreshold" -DomainName $DomainName -DomainNetbiosName $NETBIOSName -InstallDns:$true -DatabasePath $NTDSDBPath -LogPath $NTDSLogPath -NoRebootOnCompletion:$false -SysvolPath $SYSVOLPath -Force:$true -SafeModeAdministratorPassword $DSRM