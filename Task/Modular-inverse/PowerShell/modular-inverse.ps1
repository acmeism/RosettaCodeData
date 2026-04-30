function invmod($a,$n){
        if ([int]$n -lt 0) {$n = -$n}
        if ([int]$a -lt 0) {$a = $n - ((-$a) % $n)}

	$t = 0
	$nt = 1
	$r = $n
	$nr = $a % $n
	while ($nr -ne 0) {
		$q = [Math]::truncate($r/$nr)
		$tmp = $nt
		$nt = $t - $q*$nt
		$t = $tmp
		$tmp = $nr
		$nr = $r - $q*$nr
		$r = $tmp
	}
	if ($r -gt 1) {return -1}
	if ($t -lt 0) {$t += $n}
	return $t
}

invmod 42 2017
