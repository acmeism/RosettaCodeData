function conjugate-transpose($a) {
    $arr = @()
    if($a) {
        $n = $a.count - 1
        if(0 -lt $n) {
            $m = ($a | foreach {$_.count} | measure-object -Minimum).Minimum - 1
            if( 0 -le $m) {
                if (0 -lt $m) {
                    $arr =@(0)*($m+1)
                    foreach($i in 0..$m) {
                        $arr[$i] = foreach($j in 0..$n) {@([System.Numerics.complex]::Conjugate($a[$j][$i]))}
                    }
                } else {$arr = foreach($row in $a) {[System.Numerics.complex]::Conjugate($row[0])}}
            }
        } else {$arr = foreach($row in $a) {[System.Numerics.complex]::Conjugate($row[0])}}
    }
    $arr
}

function multarrays-complex($a, $b) {
    $c = @()
    if($a -and $b) {
        $n = $a.count - 1
        $m = $b[0].count - 1
        $c = @([System.Numerics.complex]::new(0,0))*($n+1)
        foreach ($i in 0..$n) {
            $c[$i] = foreach ($j in 0..$m) {
                [System.Numerics.complex]$sum = [System.Numerics.complex]::new(0,0)
                foreach ($k in 0..$n){$sum = [System.Numerics.complex]::Add($sum, ([System.Numerics.complex]::Multiply($a[$i][$k],$b[$k][$j])))}
                $sum
            }
        }
    }
    $c
}

function identity-complex($n) {
    if(0 -lt $n) {
        $array = @(0) * $n
        foreach ($i in 0..($n-1)) {
            $array[$i] = @([System.Numerics.complex]::new(0,0)) * $n
            $array[$i][$i] = [System.Numerics.complex]::new(1,0)
        }
        $array
    } else { @() }
}

function are-eq ($a,$b) { -not (Compare-Object $a $b -SyncWindow 0)}

function show($a) {
    if($a) {
        0..($a.Count - 1) | foreach{ if($a[$_]){"$($a[$_])"}else{""} }
    }
}
function complex($a,$b) {[System.Numerics.complex]::new($a,$b)}

$id2 = identity-complex 2
$m = @(@((complex 2 7), (complex 9 -5)),@((complex 3 4), (complex 8 -6)))
$hm = conjugate-transpose $m
$mhm = multarrays-complex $m $hm
$hmm = multarrays-complex $hm $m
"`$m ="
show $m
""
"`$hm = conjugate-transpose `$m ="
show $hm
""
"`$m * `$hm ="
show $mhm
""
"`$hm * `$m ="
show $hmm
""
"Hermitian? `$m = $(are-eq $m $hm)"
"Normal? `$m = $(are-eq $mhm $hmm)"
"Unitary? `$m = $((are-eq $id2 $hmm) -and (are-eq $id2 $mhm))"
