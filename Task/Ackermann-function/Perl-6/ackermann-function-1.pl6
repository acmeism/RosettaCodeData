sub A(Int $m, Int $n) {

	$m == 0  ??    $n + 1                   !!
	$n == 0  ??  A($m - 1, 1            )   !!
	             A($m - 1, A($m, $n - 1));

}
