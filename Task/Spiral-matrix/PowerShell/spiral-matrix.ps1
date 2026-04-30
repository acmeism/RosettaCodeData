function Spiral-Matrix ( [int]$N )
    {
    #  Initialize variables
    $X = 0
    $Y = -1
    $i = 0
    $Sign = 1

    #  Intialize array
    $A = New-Object 'int[,]' $N, $N

    #  Set top row
    1..$N | ForEach { $Y += $Sign; $A[$X,$Y] = ++$i }

    #  For each remaining half spiral...
    ForEach ( $M in ($N-1)..1 )
        {
        #  Set the vertical quarter spiral
        1..$M | ForEach { $X += $Sign; $A[$X,$Y] = ++$i }

        #  Curve the spiral
        $Sign = -$Sign

        #  Set the horizontal quarter spiral
        1..$M | ForEach { $Y += $Sign; $A[$X,$Y] = ++$i }
        }

    #  Convert the array to text output
    $Spiral = ForEach ( $X in 1..$N ) { ( 1..$N | ForEach { $A[($X-1),($_-1)] } ) -join "`t" }

    return $Spiral
    }

Spiral-Matrix 5
""
Spiral-Matrix 7
