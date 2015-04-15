function Start-LTProcess
{
<#
.Synopsis
   LT helper for starting slient installations.
.DESCRIPTION
   Used from starting silent installations with LabTech scripts.
   Designed to handle failures and timeout in the event of a hung installation.
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>

    [CmdletBinding(PositionalBinding=$true)]
    [OutputType()]
    Param
    (
        # Path to the executable.
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]
        $FilePath,

        # Any parameters needed by the executable.
        [Parameter(Mandatory=$false,
                   Position=1)]
        [string[]]
        $ArgumentList = @(),

        # Time out for installation, default is ten minutes in milliseconds.
        [Parameter(Mandatory=$false,
                   Position=2)]
        [int32]
        $TimeOut = 600000
    )

    Begin
    {
    }
    Process
    {
        try
        {
            $process = Start-Process -FilePath $FilePath -ArgumentList $ArgumentList -PassThru
            while(!$process.HasExited -eq $false)
            {
                Write-Output "The $($FilePath.Substring($FilePath.LastIndexOf('\') + 1)) file installed successfully."
            }
        }
        catch [System.Exception]
        {
            if($process.HasExited)
            {
                Write-Output "The $($FilePath.Substring($FilePath.LastIndexOf('\') + 1)) file did not install, please install manually."
            }
            else
            {
                $process.Kill()
                Write-Output "The $($FilePath.Substring($FilePath.LastIndexOf('\') + 1)) file did not install, please install manually."
            }
        }
        if(!$process.WaitForExit($TimeOut))
        {
            $process.Kill()
            Write-Output "The $($FilePath.Substring($FilePath.LastIndexOf('\') + 1)) file did not install, please install manually."
        }
    }
    End
    {
    }
}