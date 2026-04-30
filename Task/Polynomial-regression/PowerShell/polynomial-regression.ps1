function qr([double[][]]$A) {
    $m,$n = $A.count, $A[0].count
    $pm,$pn = ($m-1), ($n-1)
    [double[][]]$Q = 0..($m-1) | foreach{$row = @(0) * $m; $row[$_] = 1; ,$row}
    [double[][]]$R = $A | foreach{$row = $_; ,@(0..$pn | foreach{$row[$_]})}
    foreach ($h in 0..$pn) {
        [double[]]$u = $R[$h..$pm] | foreach{$_[$h]}
        [double]$nu = $u | foreach {[double]$sq = 0} {$sq += $_*$_} {[Math]::Sqrt($sq)}
        $u[0] -= if ($u[0] -lt 1) {$nu} else {-$nu}
        [double]$nu = $u | foreach {$sq = 0} {$sq += $_*$_} {[Math]::Sqrt($sq)}
        [double[]]$u = $u | foreach { $_/$nu}
        [double[][]]$v = 0..($u.Count - 1) | foreach{$i = $_; ,($u | foreach{2*$u[$i]*$_})}
        [double[][]]$CR = $R | foreach{$row = $_; ,@(0..$pn | foreach{$row[$_]})}
        [double[][]]$CQ = $Q | foreach{$row = $_; ,@(0..$pm | foreach{$row[$_]})}
        foreach ($i in  $h..$pm) {
            foreach ($j in  $h..$pn) {
                $R[$i][$j] -=  $h..$pm | foreach {[double]$sum = 0} {$sum += $v[$i-$h][$_-$h]*$CR[$_][$j]} {$sum}
            }
        }
        if (0 -eq $h)  {
            foreach ($i in  $h..$pm) {
                foreach ($j in  $h..$pm) {
                    $Q[$i][$j] -=  $h..$pm | foreach {$sum = 0} {$sum += $v[$i][$_]*$CQ[$_][$j]} {$sum}
                }
            }
        } else  {
            $p = $h-1
            foreach ($i in  $h..$pm) {
                foreach ($j in  0..$p) {
                    $Q[$i][$j] -=  $h..$pm | foreach {$sum = 0} {$sum += $v[$i-$h][$_-$h]*$CQ[$_][$j]} {$sum}
                }
                foreach ($j in  $h..$pm) {
                    $Q[$i][$j] -=  $h..$pm | foreach {$sum = 0} {$sum += $v[$i-$h][$_-$h]*$CQ[$_][$j]} {$sum}
                }
            }
        }
    }
    foreach ($i in  0..$pm) {
        foreach ($j in  $i..$pm) {$Q[$i][$j],$Q[$j][$i] = $Q[$j][$i],$Q[$i][$j]}
    }
    [PSCustomObject]@{"Q" = $Q; "R" = $R}
}

function leastsquares([Double[][]]$A,[Double[]]$y) {
    $QR = qr $A
    [Double[][]]$Q = $QR.Q
    [Double[][]]$R = $QR.R
    $m,$n = $A.count, $A[0].count
    [Double[]]$z = foreach ($j in  0..($m-1)) {
            0..($m-1) | foreach {$sum = 0} {$sum += $Q[$_][$j]*$y[$_]} {$sum}
    }
    [Double[]]$x = @(0)*$n
    for ($i = $n-1; $i -ge 0; $i--) {
        for ($j = $i+1; $j -lt $n; $j++) {
            $z[$i] -= $x[$j]*$R[$i][$j]
        }
        $x[$i] = $z[$i]/$R[$i][$i]
    }
    $x
}

function polyfit([Double[]]$x,[Double[]]$y,$n) {
    $m = $x.Count
    [Double[][]]$A = 0..($m-1) | foreach{$row = @(1) * ($n+1); ,$row}
    for ($i = 0; $i -lt $m; $i++) {
        for ($j = $n-1; 0 -le $j; $j--) {
            $A[$i][$j] = $A[$i][$j+1]*$x[$i]
        }
    }
    leastsquares $A $y
}

function show($m) {$m | foreach {write-host "$_"}}

$A = @(@(12,-51,4), @(6,167,-68), @(-4,24,-41))
$x = @(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
$y = @(1, 6, 17, 34, 57, 86, 121, 162, 209, 262, 321)
"polyfit "
"X^2 X constant"
"$(polyfit $x $y 2)"
