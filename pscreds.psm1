function my-sql
{
    param
    (
        [Parameter(Mandatory=$true)]
        [PSCredential]
        $Creds = [PSCredential]::Empty,
        [string]
        $Query = "Test123"
    )

    Begin
    {
        $asdf = $Creds.GetNetworkCredential().UserName
        $qwer = $Creds.GetNetworkCredential().Password
    }
    Process
    {
        Write-Output $asdf
        Write-Output $qwer
        Write-Output $Query
    }
    End
    {
    }
}