#  Start with a pool large enough to meet the requirements
$Pool = [System.Collections.ArrayList]( 2..22000 )

#  Start with 1, because it's grandfathered in
$Ludic = @( 1 )

#  While the size of the pool is still larger than the next Ludic number...
While ( $Pool.Count -gt $Pool[0] )
    {
    #  Add the next Ludic number to the list
    $Ludic += $Pool[0]

    #  Remove from the pool all entries whose index is a multiple of the next Ludic number
    [math]::Truncate( ( $Pool.Count - 1 )/ $Pool[0])..0 | ForEach { $Pool.RemoveAt( $_ * $Pool[0] ) }
    }

#  Add the rest of the numbers in the pool to the list of Ludic numbers
$Ludic += $Pool.ToArray()
