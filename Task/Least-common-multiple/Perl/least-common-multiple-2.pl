sub lcm {
	use integer;
	my ($x, $y) = @_;
	my ($f, $s) = @_;
	while ($f != $s) {
		($f, $s, $x, $y) = ($s, $f, $y, $x) if $f > $s;
		$f = $s / $x * $x;
		$f += $x if $f < $s;
	}
	$f
}

print lcm(1001, 221);
