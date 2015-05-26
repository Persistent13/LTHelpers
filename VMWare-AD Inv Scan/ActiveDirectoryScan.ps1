Import-Module ActiveDirectory
$apmText = Get-Content $env:SystemRoot\Temp\LTCache\apmText.txt
$apmAdCreds = New-Object System.Management.Automation.PSCredential($apmText[0],(ConvertTo-SecureString -AsPlainText -Force $apmText[1]))

$apmADServers = Get-ADComputer -Filter {OperatingSystem -Like "*server*"} -Credential $apmAdCreds
Export-Clixml -InputObject $apmADServers -Path $env:SystemRoot\Temp\LTCache\apmADServers.xml