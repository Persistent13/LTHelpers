<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
function Verb-Noun
{
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='Medium')]
    [OutputType()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Parameter Set 1')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateCount(0,5)]
        [ValidateSet("sun", "moon", "earth")]
        [Alias("p1")]
        [int32]
        $MinimumCertAgeDays = 60,

        # Param2 help description
        [Parameter(ParameterSetName='Parameter Set 1')]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [ValidateScript({$true})]
        [ValidateRange(0,5)]
        [int32]
        $Timeout = 5000,

        # Param3 help description
        [Parameter(ParameterSetName='Another Parameter Set')]
        [ValidatePattern("[a-z]*")]
        [ValidateLength(0,15)]
        [String[]]
        $Urls = @()
    )

    Begin
    {
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
    }
    Process
    {
        foreach($Url in $Urls)
        {
            $req = [Net.HttpWebRequest]::Create($Url)
            $req.Timeout = $timeoutMilliseconds
            try
            {
                $req.GetResponse() | Out-Null
            }
            catch
            {
                Write-Output "Unable to create an HTTP/HTTPS request."
            }
            [datetime]$expiration = $req.ServicePoint.Certificate.GetExpirationDateString()
            [int]$certExpiresIn = ($expiration - $(Get-Date)).Days
            $certName = $req.ServicePoint.Certificate.GetName()
            $certPublicKeyString = $req.ServicePoint.Certificate.GetPublicKeyString()
            $certSerialNumber = $req.ServicePoint.Certificate.GetSerialNumberString()
            $certThumbprint = $req.ServicePoint.Certificate.GetCertHashString()
            $certEffectiveDate = $req.ServicePoint.Certificate.GetEffectiveDateString()
            $certIssuer = $req.ServicePoint.Certificate.GetIssuerName()
            if($certExpiresIn -gt $MinimumCertAgeDays)
            {
                Write-Output "The certificate for site $url expires in $certExpiresIn days on $expiration."
            }
            else
            {
                Write-Output "The certificate for site $url expires in $certExpiresIn days on $expiration. Threshold is $minimumCertAgeDays days. Check details:`n`nCert name: $certName`nCert public key: $certPublicKeyString`nCert serial number: $certSerialNumber`nCert thumbprint: $certThumbprint`nCert effective date: $certEffectiveDate`nCert issuer: $certIssuer -f Red"
            }
        }
    }
    End
    {
        
    }
}