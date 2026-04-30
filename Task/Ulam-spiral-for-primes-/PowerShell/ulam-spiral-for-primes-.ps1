function New-UlamSpiral ( [int]$N )
    {
    #  Generate list of primes
    $Primes = @( 2 )
    For ( $X = 3; $X -le $N*$N; $X += 2 )
        {
        If ( -not ( $Primes | Where { $X % $_ -eq 0 } | Select -First 1 ) ) { $Primes += $X }
        }

    #  Initialize variables
    $X = 0
    $Y = -1
    $i = $N * $N + 1
    $Sign = 1

    #  Intialize array
    $A = New-Object 'boolean[,]' $N, $N

    #  Set top row
    1..$N | ForEach { $Y += $Sign; $A[$X,$Y] = --$i -in $Primes }

    #  For each remaining half spiral...
    ForEach ( $M in ($N-1)..1 )
        {
        #  Set the vertical quarter spiral
        1..$M | ForEach { $X += $Sign; $A[$X,$Y] = --$i -in $Primes }

        #  Curve the spiral
        $Sign = -$Sign

        #  Set the horizontal quarter spiral
        1..$M | ForEach { $Y += $Sign; $A[$X,$Y] = --$i -in $Primes }
        }

    #  Convert the array of booleans to text output of dots and spaces
    $Spiral = ForEach ( $X in 1..$N ) { ( 1..$N | ForEach { ( ' ', '.' )[$A[($X-1),($_-1)]] } ) -join '' }
    return $Spiral
    }

New-UlamSpiral 100
