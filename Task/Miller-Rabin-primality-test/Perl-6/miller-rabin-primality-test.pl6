# the expmod-function from: http://rosettacode.org/wiki/Modular_exponentiation
sub expmod(Int $a is copy, Int $b is copy, $n) {
	my $c = 1;
	repeat while $b div= 2 {
		($c *= $a) %= $n if $b % 2;
		($a *= $a) %= $n;
	}
	$c;
}

subset PrimeCandidate of Int where { $_ > 2 and $_ % 2 };

my Bool multi sub is-prime(Int $n, Int $k)            { return False; }
my Bool multi sub is-prime(2, Int $k)                 { return True; }
my Bool multi sub is-prime(PrimeCandidate $n, Int $k) {
	my Int $d = $n - 1;
	my Int $s = 0;

	while $d %% 2 {
		$d div= 2;
		$s++;
	}

	for (2 ..^ $n).pick($k) -> $a {
		my $x = expmod($a, $d, $n);

		# one could just write "next if $x == 1 | $n - 1"
		# but this takes much more time in current rakudo/nom
		next if $x == 1 or $x == $n - 1;

		for 1 ..^ $s {
			$x = $x ** 2 mod $n;
			return False if $x == 1;
			last if $x == $n - 1;
		}
		return False if $x !== $n - 1;
	}

	return True;
}

say (1..1000).grep({ is-prime($_, 10) }).join(", ");
