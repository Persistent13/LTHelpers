param($args)
ping $args[0]
if($?)
{
    Write-Output $true
}
else
{
    Write-Output $false
}