function eratosthenes ($n) {
    if($n -ge 1){
        $prime = @(1..($n+1) | foreach{$true})
        $prime[1] = $false
        $m = [Math]::Floor([Math]::Sqrt($n))
        for($i = 2; $i -le $m; $i++) {
            if($prime[$i]) {
                for($j = $i*$i; $j -le $n; $j += $i) {
                    $prime[$j] = $false
                }
            }
        }
        1..$n | where{$prime[$_]}
    } else {
        "$n must be equal or greater than 1"
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
$OFS = " x "
"$(prime-decomposition  2144)"
"$(prime-decomposition  100)"
"$(prime-decomposition  12)"
