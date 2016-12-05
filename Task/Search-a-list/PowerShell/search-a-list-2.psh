function Find-Needle
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]
        $Needle,

        [Parameter(Mandatory=$true, Position=1)]
        [string[]]
        $Haystack,

        [switch]
        $LastIndex
    )

    if ($LastIndex)
    {
        $index = [Array]::LastIndexOf($Haystack,$Needle)

        if ($index -eq -1)
        {
            Write-Verbose "Needle not found in Haystack"
            return $index
        }

        if ((($Haystack | Group-Object | Where-Object Count -GT 1).Group).IndexOf($Needle) -ne -1)
        {
            Write-Verbose "Last needle found in Haystack at index $index"
        }
        else
        {
            Write-Verbose "Needle found in Haystack at index $index  (No duplicates were found)"
        }

        return $index
    }
    else
    {
        $index = [Array]::IndexOf($Haystack,$Needle)

        if ($index -eq -1)
        {
            Write-Verbose "Needle not found in Haystack"
        }
        else
        {
            Write-Verbose "Needle found in Haystack at index $index"
        }

        return $index
    }
}

$haystack = @("word", "phrase", "preface", "title", "house", "line", "chapter", "page", "book", "house")
