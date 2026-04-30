function BinarySearch-Iterative ([int[]]$Array, [int]$Value)
{
    [int]$low = 0
    [int]$high = $Array.Count - 1

    while ($low -le $high)
    {
        [int]$mid = ($low + $high) / 2

        if ($Array[$mid] -gt $Value)
        {
            $high = $mid - 1
        }
        elseif ($Array[$mid] -lt $Value)
        {
            $low = $mid + 1
        }
        else
        {
            return $mid
        }
    }

    return -1
}

function BinarySearch-Recursive ([int[]]$Array, [int]$Value, [int]$Low = 0, [int]$High = $Array.Count)
{
    if ($High -lt $Low)
    {
        return -1
    }

    [int]$mid = ($Low + $High) / 2

    if ($Array[$mid] -gt $Value)
    {
        return BinarySearch $Array $Value $Low ($mid - 1)
    }
    elseif ($Array[$mid] -lt $Value)
    {
        return BinarySearch $Array $Value ($mid + 1) $High
    }
    else
    {
        return $mid
    }
}

function Show-SearchResult ([int[]]$Array, [int]$Search, [ValidateSet("Iterative", "Recursive")][string]$Function)
{
    switch ($Function)
    {
        "Iterative" {$index = BinarySearch-Iterative -Array $Array -Value $Search}
        "Recursive" {$index = BinarySearch-Recursive -Array $Array -Value $Search}
    }

    if ($index -ge 0)
    {
        Write-Host ("Using BinarySearch-{0}: {1} is at index {2}" -f $Function, $numbers[$index], $index)
    }
    else
    {
        Write-Host ("Using BinarySearch-{0}: {1} not found" -f $Function, $Search) -ForegroundColor Red
    }
}
