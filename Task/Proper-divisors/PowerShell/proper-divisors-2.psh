function proper-divisor ($n) {
    if($n -ge 2) {
        $lim = [Math]::Floor($n/2)+1
        $proper = @(1)
        for($i = 2; $i -lt $lim; $i++){
            if($n%$i -eq 0) {
                $proper += @($i)
            }
        }
        $proper
    } else {@()}
}
"$(proper-divisor 100)"
"$(proper-divisor 496)"
"$(proper-divisor 2048)"
