function Out-Quibble
{
    [OutputType([string])]
    Param
    (
        # Zero or more strings.
        [Parameter(Mandatory=$false, Position=0)]
        [AllowEmptyString()]
        [string[]]
        $Text = ""
    )

    # If not null or empty...
    if ($Text)
    {
        # Remove empty strings from the array.
        $text = "$Text".Split(" ", [StringSplitOptions]::RemoveEmptyEntries)
    }
    else
    {
        return "{}"
    }

    # Build a format string.
    $outStr = ""
    for ($i = 0; $i -lt $text.Count; $i++)
    {
        $outStr += "{$i}, "
    }
    $outStr = $outStr.TrimEnd(", ")

    # If more than one word, insert " and" at last comma position.
    if ($text.Count -gt 1)
    {
        $cIndex = $outStr.LastIndexOf(",")
        $outStr = $outStr.Remove($cIndex,1).Insert($cIndex," and")
    }

    # Output the formatted string.
    "{" + $outStr -f $text + "}"
}
