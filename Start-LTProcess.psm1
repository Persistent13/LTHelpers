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
        try
        {
            if(!$(Test-Path $FilePath))
            {
                throw [System.IO.FileNotFoundException]
            }
        }
        catch [System.IO.FileNotFoundException]
        {
            Write-Output "The $($FilePath.Substring($FilePath.LastIndexOf('\') + 1)) file could not be found, please verify the path exists."
        }
    }
    Process
    {
        try
        {
            $process = Start-Process -FilePath $FilePath -ArgumentList $ArgumentList -PassThru
            if((Get-ItemProperty -Path $FilePath).Extension -eq ".msi")
            {
                $process = Get-Process msiexec | Sort-Object StartTime | Select-Object -Last 1 #Finds the msi process id.
            }
            while(Wait-Process -Id $process.Id -Timeout $($TimeOut / 1000)) #Converts TimeOut to seconds.
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