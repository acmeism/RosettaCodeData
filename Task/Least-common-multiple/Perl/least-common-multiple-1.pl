sub gcd {
	my ($a, $b) = @_;
	while ($a) { ($a, $b) = ($b % $a, $a) }
	$b
}

sub lcm {
	my ($a, $b) = @_;
	($a && $b) and $a / gcd($a, $b) * $b or 0
}

print lcm(1001, 221);
