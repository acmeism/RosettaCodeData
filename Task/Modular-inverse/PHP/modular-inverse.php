<?php
function invmod($a,$n){
        if ($n < 0) $n = -$n;
        if ($a < 0) $a = $n - (-$a % $n);
	$t = 0; $nt = 1; $r = $n; $nr = $a % $n;
	while ($nr != 0) {
		$quot= intval($r/$nr);
		$tmp = $nt;  $nt = $t - $quot*$nt;  $t = $tmp;
		$tmp = $nr;  $nr = $r - $quot*$nr;  $r = $tmp;
	}
	if ($r > 1) return -1;
	if ($t < 0) $t += $n;
	return $t;
}
	printf("%d\n", invmod(42, 2017));
?>
