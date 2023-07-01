function Split-String ([string]$String, [char]$Separator, [char]$Escape)
{
    if ($String -notmatch "\$Separator|\$Escape") {return $String}

    [bool]$escaping = $false
    [string]$output = ""

    for ($i = 0; $i -lt $String.Length; $i++)
    {
        [char]$character = $String.Substring($i,1)

        if ($escaping)
        {
            $output += $character
            $escaping = $false
        }
        else
        {
            switch ($character)
            {
                {$_ -eq $Separator} {$output; $output = ""; break}
                {$_ -eq $Escape}    {$escaping = $true    ; break}
                Default             {$output += $character}
            }
        }
    }

    if ($String[-1] -eq $Separator) {[String]::Empty}
}
