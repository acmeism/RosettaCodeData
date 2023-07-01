function Draw-SierpinskiCarpet ( [int]$N )
    {
    $Carpet = @( '#' ) * [math]::Pow( 3, $N )
    ForEach ( $i in 1..$N )
        {
        $S = [math]::Pow( 3, $i - 1 )
        ForEach ( $Row in 0..($S-1) )
            {
            $Carpet[$Row+$S+$S] = $Carpet[$Row] * 3
            $Carpet[$Row+$S]    = $Carpet[$Row] + ( " " * $Carpet[$Row].Length ) + $Carpet[$Row]
            $Carpet[$Row]       = $Carpet[$Row] * 3
            }
        }
    $Carpet
    }

Draw-SierpinskiCarpet 3
