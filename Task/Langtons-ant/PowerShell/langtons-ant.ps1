$Size = 100

$G = @()
1..$Size | ForEach { $G += ,( @( 1 ) * $Size ) }

$x = $y = $Size / 2

#  Direction of next move
$Dx = 1
$Dy = 0

#  While we are still on the grid...
While ( $x -ge 0 -and $y -ge 0 -and $x -lt $Size -and $y -lt $Size )
    {
    #  Change direction
    $Dx, $Dy = ( $Dy * $G[$x][$y] ), -( $Dx * $G[$x][$y] )

    #  Change state of current square
    $G[$x][$y] = -$G[$x][$y]

    #  Move forward
    $x += $Dx
    $y += $Dy
    }

#  Convert to strings for output
ForEach ( $Row in $G ) { ( $Row | ForEach { ( ' ', '', '#')[$_+1] } ) -join '' }
