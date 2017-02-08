$lt = gwmi win32_product -Filter "Name LIKE 'LabTech C%'"
$lt.Uninstall() | Out-Null
rm HKCU:\SOFTWARE\LabTech\Client -Recurse -Force
rm "$env:ProgramData\LabTech Client" -Recurse -Force