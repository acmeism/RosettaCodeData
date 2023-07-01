$odd = function ($prev) use ( &$odd ) {
	$a = fgetc(STDIN);
	if (!ctype_alpha($a)) {
		$prev();
		fwrite(STDOUT, $a);
		return $a != '.';
	}
	$clos = function () use ($a , $prev) {
		fwrite(STDOUT, $a);
		$prev();
	};
	return $odd($clos);
};
$even = function () {
	while (true) {
		$c = fgetc(STDIN);
		fwrite(STDOUT, $c);
		if (!ctype_alpha($c)) {
			return $c != ".";
		}
	}
};
$prev = function(){};
$e = false;
while ($e ? $odd($prev) : $even()) {
	$e = !$e;
}
