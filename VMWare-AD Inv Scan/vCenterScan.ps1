Add-PSSnapin VMware.VimAutomation.Core
$apmText = Get-Content $env:SystemRoot\Temp\LTCache\apmvCenter.txt
$vCenterCreds = New-Object System.Management.Automation.PSCredential($apmText[0],(ConvertTo-SecureString -AsPlainText -Force $apmText[1]))

Connect-VIServer -Server $env:COMPUTERNAME -Credential $vCenterCreds | Out-Null
$apmVMs = Get-VM
Export-Clixml -InputObject $apmVMs -Path $env:SystemRoot\Temp\LTCache\apmVMs.xml
Disconnect-VIServer -Force -Confirm:$false