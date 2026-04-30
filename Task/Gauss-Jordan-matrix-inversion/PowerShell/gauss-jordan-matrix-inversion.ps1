function gauss-jordan-inv([double[][]]$a) {
    $n = $a.count
    [double[][]]$b = 0..($n-1) | foreach{[double[]]$row = @(0) * $n; $row[$_] = 1; ,$row}
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
        if (0 -eq $akk) {throw "Irregular matrix"}
        for ($j = 0; $j -lt $n; $j++) {
            $a[$k][$j] /= $akk
            $b[$k][$j] /= $akk
        }
        for ($i = 0; $i -lt $n; $i++){
            if ($i -ne $k) {
                $aik  = $a[$i][$k]
                for ($j = 0; $j -lt $n; $j++) {
                    $a[$i][$j] -= $a[$k][$j]*$aik
                    $b[$i][$j] -= $b[$k][$j]*$aik
                }
            }
        }
    }
    $b
}
function show($a) { $a | foreach{ "$_"} }

$a = @(@(@(1, 2, 3), @(4, 1, 6), @(7, 8, 9)))
$inva = gauss-jordan-inv $a
"a ="
show $a
""
"inv(a) ="
show $inva
""

$b = @(@(2, -1, 0), @(-1, 2, -1), @(0, -1, 2))
"b ="
show $b
""
$invb = gauss-jordan-inv $b
"inv(b) ="
show $invb
