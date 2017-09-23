function Get-ProperDivisorSum ( [int]$N )
    {
    If ( $N -lt 2 ) { return 0 }

    $Sum = 1
    If ( $N -gt 3 )
        {
        $SqrtN = [math]::Sqrt( $N )
        ForEach ( $Divisor in 2..$SqrtN )
            {
            If ( $N % $Divisor -eq 0 ) { $Sum += $Divisor + $N / $Divisor }
            }
        If ( $N % $SqrtN -eq 0 ) { $Sum -= $SqrtN }
        }
    return $Sum
    }


$Deficient = $Perfect = $Abundant = 0

ForEach ( $N in 1..20000 )
    {
    Switch ( [math]::Sign( ( Get-ProperDivisorSum $N ) - $N ) )
        {
        -1 { $Deficient++ }
         0 { $Perfect++   }
         1 { $Abundant++  }
        }
    }

"Deficient: $Deficient"
"Perfect  : $Perfect"
"Abundant : $Abundant"
