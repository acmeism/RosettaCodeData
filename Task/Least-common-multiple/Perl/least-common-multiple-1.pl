sub gcd {
	my ($x, $y) = @_;
	while ($x) { ($x, $y) = ($y % $x, $x) }
	$y
}

sub lcm {
	my ($x, $y) = @_;
	($x && $y) and $x / gcd($x, $y) * $y or 0
}

print lcm(1001, 221);
