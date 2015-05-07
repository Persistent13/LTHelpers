$tempPath = "$env:windir\$(Get-Date -Format yyyy-mm-dd_HH-ss).bin"
$Request=Get-Date
#Invoke-WebRequest 'http://client.akamai.com/install/test-objects/10MB.bin' | Out-Null;
$client = New-Object System.Net.WebClient
$client.DownloadFile("http://client.akamai.com/install/test-objects/10MB.bin","$tempPath")
[int]$speed = ((10 / ((NEW-TIMESPAN –Start $Request –End (Get-Date)).totalseconds)) * 8)
"{0:N2}" -f $Speed
Remove-Item -Force $tempPath
Write-Output "$($speed) Mbit/sec"