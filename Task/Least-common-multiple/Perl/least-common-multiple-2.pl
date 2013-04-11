sub lcm {
	use integer;
	my ($x, $y) = @_;
	my ($a, $b) = @_;
	while ($a != $b) {
		($a, $b, $x, $y) = ($b, $a, $y, $x) if $a > $b;
		$a = $b / $x * $x;
		$a += $x if $a < $b;
	}
	$a
}

print lcm(1001, 221);
