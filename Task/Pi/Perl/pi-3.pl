use bigint try=>"GMP";

# Pi/4 = 4 arctan 1/5 - arctan 1/239
# expanding it with Taylor series with what's probably the dumbest method

my ($ds, $ns) = (1, 0);
my ($n5, $d5) = (16 * (25 * 3 - 1), 3 * 5**3);
my ($n2, $d2) = (4 * (239 * 239 * 3 - 1), 3 * 239**3);

sub next_term {
	my ($coef, $p) = @_[1, 2];
	$_[0] /= ($p - 4) * ($p - 2);
	$_[0] *= $p * ($p + 2) * $coef**4;
}

my $p2 = 5;
my $pow = 1;

$| = 1;
for (my $x = 5; ; $x += 4) {
	($ns, $ds) = ($ns * $d5 + $n5 * $pow * $ds, $ds * $d5);

	next_term($d5, 5, $x);
	$n5 = 16 * (5 * 5 * ($x + 2) - $x);

	while ($d5 > $d2) {
		($ns, $ds) = ($ns * $d2 - $n2 * $pow * $ds, $ds * $d2);
		$n2 = 4 * (239 * 239 * ($p2 + 2) - $p2);
		next_term($d2, 239, $p2);
		$p2 += 4;
	}

	my $ppow = 1;
	while ($pow * $n5 * 5**4 < $d5 && $pow * $n2 * $n2 * 239**4 < $d2) {
		$pow *= 10;
		$ppow *= 10;
	}

	if ($ppow > 1) {
		$ns *= $ppow;
	#FIX?	my $out = $ns->bdiv($ds);   # bugged?
		my $out = $ns / $ds;
		$ns %= $ds;

		$out = ("0" x (length($ppow) - length($out) - 1)) . $out;
		print $out;
	}

	if ( $p2 % 20 == 1) {
		my $g = Math::BigInt::bgcd($ds, $ns);
		$ds /= $g;
		$ns /= $g;
	}
}
