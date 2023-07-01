function Get-LongestSubsequence ( [int[]]$A )
    {
    If ( $A.Count -lt 2 ) { return $A }

    #  Start with an "empty" pile
    #  (We will only store the top value in each "pile".)
    $Pile = @( [int]::MaxValue )
    $Last = 0

    #  Hashtable to hold the back pointers
    $BP = @{}

    #  For each number in the orginal sequence...
    ForEach ( $N in $A )
        {
        #  Find the first pile with a value greater than N
        $i = 0..$Last | Where { $N -lt $Pile[$_] } | Select -First 1

        #  Place N on the pile
        $Pile[$i] = $N

        #  Set the back pointer for this value to the value of the previous pile
        $BP["$N"] = $Pile[$i-1]

        #  If this is the previously empty pile, add a new empty pile
        If ( $i -eq $Last )
            {
            $Pile += @( [int]::MaxValue )
            $Last++
            }
        }

    #  Ignore the empty pile
    $Last--

    #  Start with the value of the last pile
    $N = $Pile[$Last]
    $S = @( $N )

    #  Add the remainder of the values by walking through the back pointers
    ForEach ( $i in $Last..1 )
        {
        $S += ( $N = $BP["$N"] )
        }

    #  Return the series (reversed into the correct order)
    return $S[$Last..0]
    }
