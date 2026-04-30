function Update-ConfigurationFile
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$false,
                   Position=0)]
        [ValidateScript({Test-Path $_})]
        [string]
        $Path = ".\config.txt",

        [Parameter(Mandatory=$false)]
        [string]
        $FavouriteFruit,

        [Parameter(Mandatory=$false)]
        [int]
        $NumberOfBananas,

        [Parameter(Mandatory=$false)]
        [int]
        $NumberOfStrawberries,

        [Parameter(Mandatory=$false)]
        [ValidateSet("On", "Off")]
        [string]
        $NeedsPeeling,

        [Parameter(Mandatory=$false)]
        [ValidateSet("On", "Off")]
        [string]
        $SeedsRemoved
    )

    [string[]]$lines = Get-Content $Path

    Clear-Content $Path

    if (-not ($lines | Select-String -Pattern "^\s*NumberOfStrawberries" -Quiet))
    {
        "", "# How many strawberries we have", "NumberOfStrawberries 0" | ForEach-Object {$lines += $_}
    }

    foreach ($line in $lines)
    {
        $line = $line -replace "^\s*",""  ## Strip leading whitespace

        if ($line -match "[;].*\s*") {continue}  ## Strip semicolons

        switch -Regex ($line)
        {
            "(^$)|(^#\s.*)"                                              ## Blank line or comment
            {
                $line = $line
            }
            "^FavouriteFruit\s*.*"                                       ## Parameter FavouriteFruit
            {
                if ($FavouriteFruit)
                {
                    $line = "FAVOURITEFRUIT $FavouriteFruit"
                }
            }
            "^NumberOfBananas\s*.*"                                      ## Parameter NumberOfBananas
            {
                if ($NumberOfBananas)
                {
                    $line = "NUMBEROFBANANAS $NumberOfBananas"
                }
            }
            "^NumberOfStrawberries\s*.*"                                 ## Parameter NumberOfStrawberries
            {
                if ($NumberOfStrawberries)
                {
                    $line = "NUMBEROFSTRAWBERRIES $NumberOfStrawberries"
                }
            }
            ".*NeedsPeeling\s*.*"                                        ## Parameter NeedsPeeling
            {
                if ($NeedsPeeling -eq "On")
                {
                    $line = "NEEDSPEELING"
                }
                elseif ($NeedsPeeling -eq "Off")
                {
                    $line = "; NEEDSPEELING"
                }
            }
            ".*SeedsRemoved\s*.*"                                        ## Parameter SeedsRemoved
            {
                if ($SeedsRemoved -eq "On")
                {
                    $line = "SEEDSREMOVED"
                }
                elseif ($SeedsRemoved -eq "Off")
                {
                    $line = "; SEEDSREMOVED"
                }
            }
            Default                                                      ## Whatever...
            {
                $line = $line
            }
        }

        Add-Content $Path -Value $line -Force
    }
}
