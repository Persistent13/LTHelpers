# Connect to Windows Update
$wuSession = New-Object -ComObject Microsoft.Update.Session
$searchSession = $wuSession.CreateUpdateSearcher()

# Save Windows Update status of last update
$wuStatus = $searchSession.QueryHistory(1,1)

# Gets days since last updates where applied
$daysSinceLastUpdate = $($wuStatus).Date - $(Get-Date)

# We remove the "-" by pulling the absolute value
[Math]::Abs($daysSinceLastUpdate.Days)
