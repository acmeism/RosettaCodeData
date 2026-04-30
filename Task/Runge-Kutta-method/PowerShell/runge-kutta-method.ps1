function Runge-Kutta (${function:F}, ${function:y}, $y0, $t0, $dt, $tEnd) {
    function RK ($tn,$yn)  {
        $y1 = $dt*(F -t $tn -y $yn)
        $y2 = $dt*(F -t ($tn + (1/2)*$dt) -y ($yn + (1/2)*$y1))
        $y3 = $dt*(F -t ($tn + (1/2)*$dt) -y ($yn + (1/2)*$y2))
        $y4 = $dt*(F -t ($tn + $dt) -y ($yn + $y3))
        $yn + (1/6)*($y1 + 2*$y2 + 2*$y3 + $y4)
    }
    function time ($t0, $dt, $tEnd)  {
        $end = [MATH]::Floor(($tEnd - $t0)/$dt)
        foreach ($_ in 0..$end) { $_*$dt + $t0 }
    }
    $time, $yn, $t = (time $t0 $dt $tEnd), $y0, 0
    foreach ($tn in $time) {
        if($t -eq $tn) {
            [pscustomobject]@{
                t = "$tn"
                y = "$yn"
                error = "$([MATH]::abs($yn - (y $tn)))"
            }
            $t += 1
        }
        $yn = RK $tn $yn
    }
}
function F ($t,$y)  {
    $t * [MATH]::Sqrt($y)
}
function y ($t)  {
    (1/16) * [MATH]::Pow($t*$t + 4,2)
}
$y0 = 1
$t0 = 0
$dt = 0.1
$tEnd = 10
Runge-Kutta  F y $y0 $t0  $dt  $tEnd
