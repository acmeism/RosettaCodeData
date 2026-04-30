function agm ([Double]$a, [Double]$g) {
    [Double]$eps = 1E-15
    [Double]$a1 = [Double]$g1 = 0
    while([Math]::Abs($a - $g) -gt $eps) {
        $a1, $g1 = $a, $g
        $a = ($a1 + $g1)/2
        $g = [Math]::Sqrt($a1*$g1)
    }
    [pscustomobject]@{
        a = "$a"
        g = "$g"
    }
}
agm 1 (1/[Math]::Sqrt(2))
