function cholesky ($a) {
    $l = @()
    if ($a) {
        $n = $a.count
        $end = $n - 1
        $l = 1..$n | foreach {$row = @(0) * $n; ,$row}
        foreach ($k in 0..$end) {
            $m = $k - 1
            $sum = 0
            if(0 -lt $k) {
                foreach ($j in 0..$m) {$sum += $l[$k][$j]*$l[$k][$j]}
            }
            $l[$k][$k] = [Math]::Sqrt($a[$k][$k] - $sum)
            if ($k -lt $end) {
                foreach ($i in ($k+1)..$end) {
                    $sum = 0
                    if (0 -lt $k) {
                        foreach ($j in 0..$m) {$sum += $l[$i][$j]*$l[$k][$j]}
                    }
                    $l[$i][$k] = ($a[$i][$k] - $sum)/$l[$k][$k]
                }
            }
        }
    }
    $l
}

function show($a) {$a | foreach {"$_"}}

$a1 = @(
@(25, 15, -5),
@(15, 18, 0),
@(-5, 0, 11)
)
"a1 ="
show $a1
""
"l1 ="
show (cholesky $a1)
""
$a2 = @(
@(18, 22, 54, 42),
@(22, 70, 86, 62),
@(54, 86, 174, 134),
@(42, 62, 134, 106)
)
"a2 ="
show $a2
""
"l2 ="
show (cholesky $a2)
