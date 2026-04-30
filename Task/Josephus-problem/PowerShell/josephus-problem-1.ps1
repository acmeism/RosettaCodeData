function Get-JosephusPrisoners ( [int]$N, [int]$K )
    {
    #  Just for convenience
    $End = $N - 1

    #  Create circle of prisoners
    $Prisoners = New-Object System.Collections.ArrayList ( , (0..$End) )

    #  For each starting point of the reducing circle...
    ForEach ( $Start in 0..($End - 1) )
        {
        #  We subtract one from K for the one we advanced by incrementing $Start
        #  Then take K modulus the length of the remaining circle
        $RoundK = ( $K - 1 ) % ( $End - $Start + 1 )

        #  Rotate the remaining prisoners K places around the remaining circle
        $Prisoners.SetRange( $Start, $Prisoners[ $Start..$End ][ ( $RoundK + $Start - $End - 1 )..( $RoundK - 1 ) ] )
        }
    return $Prisoners
    }
