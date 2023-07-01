function Read-ConfigurationFile
{
    [CmdletBinding()]
    Param
    (
        # Path to the configuration file.  Default is "C:\ConfigurationFile.cfg"
        [Parameter(Mandatory=$false, Position=0)]
        [string]
        $Path = "C:\ConfigurationFile.cfg"
    )

    [string]$script:fullName = ""
    [string]$script:favouriteFruit = ""
    [bool]$script:needsPeeling = $false
    [bool]$script:seedsRemoved = $false
    [string[]]$script:otherFamily = @()

    function Get-Value ([string]$Line)
    {
        if ($Line -match "=")
        {
            [string]$value = $Line.Split("=",2).Trim()[1]
        }
        elseif ($Line -match " ")
        {
            [string]$value = $Line.Split(" ",2).Trim()[1]
        }

        $value
    }

    # Process each line in file that is not a comment.
    Get-Content $Path | Select-String -Pattern "^[^#;]" | ForEach-Object {

        [string]$line = $_.Line.Trim()

        if ($line -eq [String]::Empty)
        {
            # do nothing for empty lines
        }
        elseif ($line.ToUpper().StartsWith("FULLNAME"))
        {
            $script:fullName = Get-Value $line
        }
        elseif ($line.ToUpper().StartsWith("FAVOURITEFRUIT"))
        {
            $script:favouriteFruit = Get-Value $line
        }
        elseif ($line.ToUpper().StartsWith("NEEDSPEELING"))
        {
            $script:needsPeeling = $true
        }
        elseif ($line.ToUpper().StartsWith("SEEDSREMOVED"))
        {
            $script:seedsRemoved = $true
        }
        elseif ($line.ToUpper().StartsWith("OTHERFAMILY"))
        {
            $script:otherFamily = (Get-Value $line).Split(',').Trim()
        }
    }

    Write-Verbose -Message ("{0,-15}= {1}" -f "FULLNAME", $script:fullName)
    Write-Verbose -Message ("{0,-15}= {1}" -f "FAVOURITEFRUIT", $script:favouriteFruit)
    Write-Verbose -Message ("{0,-15}= {1}" -f "NEEDSPEELING", $script:needsPeeling)
    Write-Verbose -Message ("{0,-15}= {1}" -f "SEEDSREMOVED", $script:seedsRemoved)
    Write-Verbose -Message ("{0,-15}= {1}" -f "OTHERFAMILY", ($script:otherFamily -join ", "))
}
