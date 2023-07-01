function gauss($a,$b) {
    $n = $a.count
    for ($k = 0; $k -lt $n; $k++) {
        $lmax, $max = $k, [Math]::Abs($a[$k][$k])
        for ($l = $k+1; $l -lt $n; $l++) {
            $tmp = [Math]::Abs($a[$l][$k])
            if($max -lt $tmp) {
                $max, $lmax = $tmp, $l
            }
        }
        if ($k -ne $lmax) {
            $a[$k], $a[$lmax] = $a[$lmax], $a[$k]
            $b[$k], $b[$lmax] = $b[$lmax], $b[$k]
        }
        $akk = $a[$k][$k]
        for ($i = $k+1; $i -lt $n; $i++){
            $aik  = $a[$i][$k]
            for ($j = $k; $j -lt $n; $j++) {
                $a[$i][$j] = $a[$i][$j]*$akk - $a[$k][$j]*$aik
            }
            $b[$i] = $b[$i]*$akk - $b[$k]*$aik
        }
    }
    for ($i = $n-1; $i -ge 0; $i--) {
        for ($j = $i+1; $j -lt $n; $j++) {
            $b[$i] -= $b[$j]*$a[$i][$j]
        }
        $b[$i] = $b[$i]/$a[$i][$i]
    }
    $b
}
function show($a) {
    if($a) {
        0..($a.Count - 1) | foreach{ if($a[$_]){"$($a[$_][0..($a[$_].count -1)])"}else{""} }
    }
}
$a =(
@(1.00, 0.00, 0.00,  0.00,  0.00, 0.00),
@(1.00, 0.63, 0.39,  0.25,  0.16, 0.10),
@(1.00, 1.26, 1.58,  1.98,  2.49, 3.13),
@(1.00, 1.88, 3.55,  6.70, 12.62, 23.80),
@(1.00, 2.51, 6.32, 15.88, 39.90, 100.28),
@(1.00, 3.14, 9.87, 31.01, 97.41, 306.02)
)
"a ="
show $a
""
$b = @(-0.01, 0.61, 0.91, 0.99, 0.60, 0.02)
"b ="
$b
""
"x ="
gauss $a $b
