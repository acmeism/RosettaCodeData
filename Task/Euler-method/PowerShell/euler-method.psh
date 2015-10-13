function euler (${f}, ${y}, $y0, $t0, $tEnd) {
    function f-euler ($tn, $yn, $h)  {
        $yn + $h*(f $tn $yn)
    }
    function time ($t0, $h, $tEnd)  {
        $end = [MATH]::Floor(($tEnd - $t0)/$h)
        foreach ($_ in 0..$end) { $_*$h + $t0 }
    }
    $time = time $t0 10 $tEnd
    $time5 = time $t0 5 $tEnd
    $time2 = time $t0 2 $tEnd
    $yn10 = $yn5 = $yn2 = $y0
    $i2 = $i5 = 0
    foreach ($tn10 in $time) {
        while($time2[$i2] -ne $tn10) {
            $i2++
            $yn2 = (f-euler $time2[$i2] $yn2 2)
        }
        while($time5[$i5] -ne $tn10) {
            $i5++
            $yn5 = (f-euler $time5[$i5] $yn5 5)
        }
        [pscustomobject]@{
            t = "$tn10"
            Analytical = "$("{0:N5}" -f (y $tn10))"
            "Euler h = 2" = "$("{0:N5}" -f $yn2)"
            "Euler h = 5" = "$("{0:N5}" -f $yn5)"
            "Euler h = 10" = "$("{0:N5}" -f $yn10)"
            "Error h = 2" = "$("{0:N5}" -f [MATH]::abs($yn2 - (y $tn10)))"
            "Error h = 5" = "$("{0:N5}" -f [MATH]::abs($yn5 - (y $tn10)))"
            "Error h = 10" = "$("{0:N5}" -f [MATH]::abs($yn10 - (y $tn10)))"
        }
        $yn10 = (f-euler $tn10 $yn10 10)
    }
}
$k, $yr, $y0, $t0, $tEnd = 0.07, 20, 100, 0, 100
function f ($t, $y)  {
    -$k *($y - $yr)
}
function y ($t)  {
    $yr + ($y0 - $yr)*[MATH]::Exp(-$k*$t)
}
euler f y $y0 $t0 $tEnd | Format-Table -AutoSize
