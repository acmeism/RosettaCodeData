<?php
$a = array();
array_push($a, 0);

$used = array();
array_push($used, 0);

$used1000 = array();
array_push($used1000, 0);

$foundDup = false;
$n = 1;

while($n <= 15 || !$foundDup || count($used1000) < 1001) {
	$next = $a[$n - 1] - $n;
	if ($next < 1 || in_array($next, $used)) {
		$next += 2 * $n;
	}
	$alreadyUsed = in_array($next, $used);
	array_push($a, $next);
	if (!$alreadyUsed) {
		array_push($used, $next);
		if (0 <= $next && $next <= 1000) {
			array_push($used1000, $next);
		}
	}
	if ($n == 14) {
		echo "The first 15 terms of the Recaman sequence are : [";
		foreach($a as $i => $v) {
			if ( $i == count($a) - 1)
				echo "$v";
			else
				echo "$v, ";
		}
		echo "]\n";
	}
	if (!$foundDup && $alreadyUsed) {
		printf("The first duplicate term is a[%d] = %d\n", $n, $next);
		$foundDup = true;
	}
	if (count($used1000) == 1001) {
		printf("Terms up to a[%d] are needed to generate 0 to 1000\n", $n);
	}
	$n++;
}
