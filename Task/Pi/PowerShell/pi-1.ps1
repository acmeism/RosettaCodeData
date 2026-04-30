Function Get-Pi ( $Digits )
    {
    $Big = [bigint[]](0..10)

    $ndigits = 0
    $Output = ""

    $q = $t = $k = $Big[1]
    $r =           $Big[0]
    $l = $n =      $Big[3]
    # Calculate first digit
    $nr = ( $Big[2] * $q + $r ) * $l
    $nn = ( $q * ( $Big[7] * $k + $Big[2] ) + $r * $l ) / ( $t * $l )
    $q *= $k
    $t *= $l
    $l += $Big[2]
    $k = $k + $Big[1]
    $n = $nn
    $r = $nr

    $Output += [string]$n + '.'
    $ndigits++

    $nr = $Big[10] * ( $r - $n * $t )
    $n = ( ( $Big[10] * ( 3 * $q + $r ) ) / $t ) - 10 * $n
    $q *= $Big[10]
    $r = $nr

    While ( $ndigits -lt $Digits )
        {
        While ( $ndigits % 100 -ne 0 -or -not $Output )
            {
            If ( $Big[4] * $q + $r - $t -lt $n * $t )
                {
                $Output += [string]$n
                $ndigits++
                $nr = $Big[10] * ( $r - $n * $t )
                $n = ( ( $Big[10] * ( 3 * $q + $r ) ) / $t ) - 10 * $n
                $q *= $Big[10]
                $r = $nr
                }
            Else
                {
                $nr = ( $Big[2] * $q + $r ) * $l
                $nn = ( $q * ( $Big[7] * $k + $Big[2] ) + $r * $l ) / ( $t * $l )
                $q *= $k
                $t *= $l
                $l += $Big[2]
                $k = $k + $Big[1]
                $n = $nn
                $r = $nr
                }
            }
        $Output
        $Output = ""
        }
    }
