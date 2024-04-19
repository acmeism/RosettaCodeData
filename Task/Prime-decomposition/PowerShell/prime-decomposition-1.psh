function eratosthenes ($n) {
    if($n -gt 1){
        $prime = @(1..($n+1) | foreach{$true})
        $prime[1] = $false
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
        1..$n | where{$prime[$_]}
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
"$(prime-decomposition 12)"
"$(prime-decomposition 100)"
