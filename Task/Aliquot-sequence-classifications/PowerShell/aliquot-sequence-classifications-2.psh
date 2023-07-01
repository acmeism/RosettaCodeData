function Get-NextAliquot ( [int]$X )
    {
    If ( $X -gt 1 )
        {
        $NextAliquot = 1
        If ( $X -gt 2 )
            {
            $XSquareRoot = [math]::Sqrt( $X )

            (2..$XSquareRoot).Where{ $X % $_ -eq 0 }.ForEach{ $NextAliquot += $_ + $x / $_ }

            If ( $XSquareRoot % 1 -eq 0 ) { $NextAliquot -= $XSquareRoot }
            }
        return $NextAliquot
        }
    }

function Get-AliquotSequence ( [int]$K, [int]$N )
    {
    $X = $K
    $X
    $i = 1
    While ( $X -and $i -lt $N )
        {
        $i++
        $Next = Get-NextAliquot $X
        If ( $Next )
            {
            If ( $X -eq $Next )
                {
                ($i..$N).ForEach{ $X }
                $i = $N
                }
            Else
                {
                $X = $Next
                $X
                }
            }
        Else
            {
            $i = $N
            }
        }
    }

function Classify-AlliquotSequence ( [int[]]$Sequence )
    {
    $K = $Sequence[0]
    $LastN = $Sequence.Count
    If ( $Sequence[-1] -eq 0 ) { return "terminating" }
    If ( $Sequence[-1] -eq 1 ) { return "terminating" }
    If ( $Sequence[1] -eq $K ) { return "perfect"     }
    If ( $Sequence[2] -eq $K ) { return "amicable"    }
    If ( $Sequence[3..($Sequence.Count-1)] -contains $K ) { return "sociable" }
    If ( $Sequence[-1] -eq $Sequence[-2] ) { return "aspiring" }
    If ( $Sequence.Count -gt ( $Sequence | Select -Unique ).Count ) { return "cyclic" }
    return "non-terminating and non-repeating through N = $($Sequence.Count)"
    }

(1..10).ForEach{ [string]$_ + " is " + ( Classify-AlliquotSequence -Sequence ( Get-AliquotSequence -K $_ -N 16 ) ) }

( 11, 12, 28, 496, 220, 1184, 12496, 1264460, 790, 909, 562, 1064, 1488 ).ForEach{ [string]$_ + " is " + ( Classify-AlliquotSequence -Sequence ( Get-AliquotSequence -K $_ -N 16 ) ) }
