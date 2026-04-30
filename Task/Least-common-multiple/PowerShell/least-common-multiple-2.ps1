function gcd ($a, $b)  {
    function pgcd ($n, $m)  {
        if($n -le $m) {
            if($n -eq 0) {$m}
            else{pgcd $n ($m%$n)}
        }
        else {pgcd $m $n}
    }
    $n = [Math]::Abs($a)
    $m = [Math]::Abs($b)
    (pgcd $n $m)
}
function lcm ($a, $b)  {
    [Math]::Abs($a*$b)/(gcd $a $b)
}
lcm 12 18
