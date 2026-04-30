function Measure-Apollonius
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (
        [int]$Counter,
        [double]$x1,
        [double]$y1,
        [double]$r1,
        [double]$x2,
        [double]$y2,
        [double]$r2,
        [double]$x3,
        [double]$y3,
        [double]$r3
    )

    switch ($Counter)
    {
        {$_ -eq 2} {$s1 = -1; $s2 = -1; $s3 = -1; break}
        {$_ -eq 3} {$s1 =  1; $s2 = -1; $s3 = -1; break}
        {$_ -eq 4} {$s1 = -1; $s2 =  1; $s3 = -1; break}
        {$_ -eq 5} {$s1 = -1; $s2 = -1; $s3 =  1; break}
        {$_ -eq 6} {$s1 =  1; $s2 =  1; $s3 = -1; break}
        {$_ -eq 7} {$s1 = -1; $s2 =  1; $s3 =  1; break}
        {$_ -eq 8} {$s1 =  1; $s2 = -1; $s3 =  1; break}
        Default    {$s1 =  1; $s2 =  1; $s3 =  1; break}
    }

    [double]$v11 = 2 * $x2 - 2 * $x1
    [double]$v12 = 2 * $y2 - 2 * $y1
    [double]$v13 = $x1 * $x1 - $x2 * $x2 + $y1 * $y1 - $y2 * $y2 - $r1 * $r1 + $r2 * $r2
    [double]$v14 = 2 * $s2 * $r2 - 2 * $s1 * $r1

    [double]$v21 = 2 * $x3 - 2 * $x2
    [double]$v22 = 2 * $y3 - 2 * $y2
    [double]$v23 = $x2 * $x2 - $x3 * $x3 + $y2 * $y2 - $y3 * $y3 - $r2 * $r2 + $r3 * $r3
    [double]$v24 = 2 * $s3 * $r3 - 2 * $s2 * $r2

    [double]$w12 = $v12 / $v11
    [double]$w13 = $v13 / $v11
    [double]$w14 = $v14 / $v11

    [double]$w22 = $v22 / $v21 - $w12
    [double]$w23 = $v23 / $v21 - $w13
    [double]$w24 = $v24 / $v21 - $w14

    [double]$P = -$w23 / $w22
    [double]$Q = $w24 / $w22
    [double]$M = -$w12 * $P - $w13
    [double]$N = $w14 - $w12 * $Q

    [double]$a = $N * $N + $Q * $Q - 1
    [double]$b = 2 * $M * $N - 2 * $N * $x1 + 2 * $P * $Q - 2 * $Q * $y1 + 2 * $s1 * $r1
    [double]$c = $x1 * $x1 + $M * $M - 2 * $M * $x1 + $P * $P + $y1 * $y1 - 2 * $P * $y1 - $r1 * $r1

    [double]$D = $b * $b - 4 * $a * $c

    [double]$rs = (-$b - [Double]::Parse([Math]::Sqrt($D).ToString())) / (2 * [Double]::Parse($a.ToString()))
    [double]$xs = $M + $N * $rs
    [double]$ys = $P + $Q * $rs

    [PSCustomObject]@{
        X      = $xs
        Y      = $ys
        Radius = $rs
    }
}
