function eratosthenes ($n) {
    if($n -gt 1){
        $prime = @(0..$n| foreach{$true})
        $m = [Math]::Floor([Math]::Sqrt($n))
        function multiple($i) {
            for($j = $i*$i; $j -le $n; $j += $i) {
                $prime[$j] = $false
            }
        }
        multiple 2
        for($i = 3; $i -le $m; $i += 2) {
            if($prime[$i]) {multiple $i}
        }
        2
        for($i = 3; $i -le $n; $i += 2) {
            if($prime[$i]) {$i}
        }

    } else {
        Write-Error "$n is not greater than 1"
    }
}
function prime-decomposition ($n) {
    $array = eratosthenes $n
    $prime = @()
    foreach($p in $array) {
        while($n%$p -eq 0) {
            $n /= $p
            $prime += @($p)
        }
    }
    $prime
}
function proper-divisor ($n) {
    if($n -ge 2) {
        $array = prime-decomposition $n
        $lim = $array.Count
        function state($res, $i){
            if($i -lt $lim) {
                state ($res) ($i + 1)
                state ($res*$array[$i]) ($i + 1)
            } elseif($res -lt $n) {$res}
        }
        state 1 0 | sort -Unique
    } else {@()}
}
"$(proper-divisor 100)"
"$(proper-divisor 496)"
"$(proper-divisor 2048)"
