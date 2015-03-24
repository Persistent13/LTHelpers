function Get-URIFile
{
<#
.Synopsis
   Downloads a file or files from the specified URIs.
.DESCRIPTION
   Downloads a file or files from the specified URIs and can make use of HTTP,
   HTTPS, and FTP requests. A lesser Invoke-WebRequest for PowerShell 2.0.
.EXAMPLE
   Get-URIFile -Uri "http://fqdn.local/path/to/object.exe"

   The above example will download the file object.exe to the current dirrectory.
.EXAMPLE
   PS C:\>Get-URIFile -Uri "http://fqdn.local/path/to/object.exe" -Destination "C:\temp 1"

   The above example will download the file object.exe to the C:\temp 1 directory.
.INPUTS
   System.Object
.OUTPUTS
   None that should be used.
.NOTES
   Currently the cmdlet will not signify if the download has completed at all.
.COMPONENT
   This cmdlet makes use of the .NET class WebClient.
#>

    [CmdletBinding()]
    [OutputType()]
    Param
    (
        # The location of the file to download.
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [String[]]
        $Uri = @(),

        # The downloaded file's distination.
        [Parameter(Mandatory=$false,
                   Position=1)]
        [String]
        $Destination = $pwd
    )

    Begin
    {
    }
    Process
    {
        for($i=0;$i -lt $Uri.Length; $i++)
        {
            $web = New-Object System.Net.WebClient
            $web.DownloadFile($Uri[$i], "$Destination\$($Uri[$i].Substring($Uri[$i].LastIndexOf('/') + 1))")
            $web.Dispose()
        }
    }
    End
    {
    }
}