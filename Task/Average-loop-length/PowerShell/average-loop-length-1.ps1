function Get-AnalyticalLoopAverage ( [int]$N )
    {
    #  Expected loop average = sum from i = 1 to N of N! / (N-i)! / N^(N-i+1)
    #  Equivalently, Expected loop average = sum from i = 1 to N of F(i)
    #    where F(N) = 1, and F(i) = F(i+1)*i/N

    $LoopAverage = $Fi = 1

    If ( $N -eq 1 ) { return $LoopAverage }

    ForEach ( $i in ($N-1)..1 )
        {
        $Fi *= $i / $N
        $LoopAverage  += $Fi
        }
    return $LoopAverage
    }

function Get-ExperimentalLoopAverage ( [int]$N, [int]$Tests = 100000 )
    {
    If ( $N -eq 1 ) { return 1 }

    #  Using 0 through N-1 instead of 1 through N for speed and simplicity
    $NMO = $N - 1

    #  Create array to hold mapping function
    $F = New-Object int[] ( $N )

    $Count = 0
    $Random = New-Object System.Random

    ForEach ( $Test in 1..$Tests )
        {
        #  Map each number to a random number
        ForEach ( $i in 0..$NMO )
            {
            $F[$i] = $Random.Next( $N )
            }

        #  For each number...
        ForEach ( $i in 0..$NMO )
            {
            #  Add the number to the list
            $List = @()
            $Count++
            $List += $X = $i

            #  If loop does not yet exist in list...
            While ( $F[$X] -notin $List )
                {
                #  Go to the next mapped number and add it to the list
                $Count++
                $List += $X = $F[$X]
                }
            }
        }
    $LoopAvereage = $Count / $N / $Tests
    return $LoopAvereage
    }
