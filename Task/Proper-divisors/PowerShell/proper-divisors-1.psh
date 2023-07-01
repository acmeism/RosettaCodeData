function proper-divisor ($n) {
    if($n -ge 2) {
        $lim = [Math]::Floor([Math]::Sqrt($n))
        $less, $greater = @(1), @()
        for($i = 2; $i -lt $lim; $i++){
            if($n%$i -eq 0) {
                $less += @($i)
                $greater = @($n/$i) + $greater
            }
        }
        if(($lim -ne 1) -and ($n%$lim -eq 0)) {$less += @($lim)}
        $($less + $greater)
    } else {@()}
}
"$(proper-divisor 100)"
"$(proper-divisor 496)"
"$(proper-divisor 2048)"
