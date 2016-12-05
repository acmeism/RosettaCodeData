function Get-ProperDivisorSum ( [int]$N )
    {
    $Sum = 1
    If ( $N -gt 3 )
        {
        $SqrtN = [math]::Sqrt( $N )
        ForEach ( $Divisor1 in 2..$SqrtN )
            {
            $Divisor2 = $N / $Divisor1
            If ( $Divisor2 -is [int] ) { $Sum += $Divisor1 + $Divisor2 }
            }
        If ( $SqrtN -is [int] ) { $Sum -= $SqrtN }
        }
    return $Sum
    }

function Get-AmicablePairs ( $N = 300 )
    {
    ForEach ( $X in 1..$N )
        {
        $Sum = Get-ProperDivisorSum $X
        If ( $Sum -gt $X -and $X -eq ( Get-ProperDivisorSum $Sum ) )
            {
            "$X, $Sum"
            }
        }
    }

Get-AmicablePairs 20000
