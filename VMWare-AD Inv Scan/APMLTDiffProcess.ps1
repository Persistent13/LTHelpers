#This script requires the PoSHMySQL module.
#https://github.com/Persistent13/PoSHMySQL

$LTServer = "cns-hq-labtech"
$PoSHMySQLPath = "\\$LTServer\LTSHARE\Transfer\Scripts\PoSHMySQL\PS.MySQL.psm1"
$csvTimeStamp = (Get-Date -Format MM-dd-yyyy_HH-mm-ss)
try{
$sqlcreds = Get-Content "\\$LTServer\LTSHARE\Transfer\Scripts\svcScript.txt"
$sqlcreds = New-Object System.Management.Automation.PSCredential($sqlcreds[0],(ConvertTo-SecureString -AsPlainText -Force $sqlcreds[1]))
}
catch
{
Write-Output $_
}

try{
Import-Module $PoSHMySQLPath
$apmvCenterServers = Import-Clixml -Path "\\$LTServer\LTSHARE\Uploads\American Pacific Mortgage\APMC-VCENTER-8071\apmVMs.xml"
$LTAPMServers = Invoke-MySQL -Query "SELECT computers.name FROM computers WHERE clientid = '80' AND os LIKE '%server%'" `
    -Credential $sqlcreds -SQLHost rmm.cns-service.com -Database labtech
$LTAPMvCenterDiff = Compare-Object -ReferenceObject $apmvCenterServers.Name -DifferenceObject $LTAPMServers.Name

$LTAPMvCenterDiff | Where-Object {$_.SideIndicator -ne "=>"} | Export-Csv -NoTypeInformation -Path "\\$LTServer\LTSHARE\APMvCenterServersDiff_$csvTimeStamp.csv"
Remove-Item -Force -Path "\\$LTServer\LTSHARE\Uploads\American Pacific Mortgage\APMC-VCENTER-8071\apmVMs.xml"
}
catch{
Write-Output $_
}

try{
$apmADServers = Import-Clixml -Path "\\$LTServer\LTSHARE\Uploads\American Pacific Mortgage\APMC-AD01-8053\apmADServers.xml"
$LTAPMADDiff = Compare-Object -ReferenceObject $apmADServers.Name -DifferenceObject $LTAPMServers.Name

$LTAPMADDiff | Where-Object {$_.SideIndicator -ne "=>"} | Export-Csv -NoTypeInformation -Path "\\$LTServer\LTSHARE\APMADServersDiff_$csvTimeStamp.csv"
Remove-Item -Force -Path "\\$LTServer\LTSHARE\Uploads\American Pacific Mortgage\APMC-AD01-8053\apmADServers.xml"
}
catch{
Write-Output $_
}