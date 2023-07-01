function Get-Lcs ($ReferenceObject, $DifferenceObject)
{
    $longestCommonSubsequence = @()
    $x = $ReferenceObject.Length
    $y = $DifferenceObject.Length

    $lengths = New-Object -TypeName 'System.Object[,]' -ArgumentList ($x + 1), ($y + 1)

    for($i = 0; $i -lt $x; $i++)
    {
        for ($j = 0; $j -lt $y; $j++)
        {
            if ($ReferenceObject[$i] -ceq $DifferenceObject[$j])
            {
                $lengths[($i+1),($j+1)] = $lengths[$i,$j] + 1
            }
            else
            {
                $lengths[($i+1),($j+1)] = [Math]::Max(($lengths[($i+1),$j]),($lengths[$i,($j+1)]))
            }
        }
    }

    while (($x -ne 0) -and ($y -ne 0))
    {
        if ( $lengths[$x,$y] -eq $lengths[($x-1),$y])
        {
            --$x
        }
        elseif ($lengths[$x,$y] -eq $lengths[$x,($y-1)])
        {
            --$y
        }
        else
        {
            if ($ReferenceObject[($x-1)] -ceq $DifferenceObject[($y-1)])
            {
                $longestCommonSubsequence = ,($ReferenceObject[($x-1)]) + $longestCommonSubsequence
            }

            --$x
            --$y
        }
    }

    $longestCommonSubsequence
}
