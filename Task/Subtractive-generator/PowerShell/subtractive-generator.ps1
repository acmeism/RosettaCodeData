function Get-SubtractiveRandom ( [int]$Seed )
    {
    function Mod ( [int]$X, [int]$M = 1000000000 ) { ( $X % $M + $M ) % $M }

    If ( $Seed )
        {
        $R = New-Object int[] 55

        $N1 = 55 - 1
        $N2 = ( $N1 + 34 ) % 55

        $R[$N1] = $Seed
        $R[$N2] = 1

        ForEach ( $x in 2..(55-1) )
            {
            $N0, $N1, $N2 = $N1, $N2, ( ( $N2 + 34 ) % 55 )
            $R[$N2] = Mod ( $R[$N0] - $R[$N1] )
            }

        $i = -55 - 1
        $j = -24 - 1

        ForEach ( $x in 55..219 )
            {
            $i = ++$i % 55
            $j = ++$j % 55
            $R[$i] = Mod ( $R[$i] - $R[$j] )
            }

        $Script:RandomRing  = $R
        $Script:RandomIndex = $i
        }

    $i = $Script:RandomIndex = ++$Script:RandomIndex % 55
    $j = ( $i + 55 - 24 ) % 55

    return ( $Script:RandomRing[$i] = Mod ( $Script:RandomRing[$i] - $Script:RandomRing[$j] ) )
    }


Get-SubtractiveRandom 292929
Get-SubtractiveRandom
Get-SubtractiveRandom
Get-SubtractiveRandom
Get-SubtractiveRandom
