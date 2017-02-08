$p = Start-Process -FilePath $env:windir\LTSvc\packages\vda\7za.exe -ArgumentList @('x',"$env:windir\LTSvc\packages\vda\VDA7.11.7z","-o$env:windir\LTSvc\packages\vda",'-y') -PassThru
while($p.HasExited -ne $true){Start-Sleep -Seconds 10}
if($p.ExitCode -eq 0){Write-Output 'Successfully extracred the VDA'}else{exit 1}
