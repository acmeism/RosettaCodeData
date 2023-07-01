use strict;
use utf8;

sub factors {
	my $n = shift;
	my $p = 2;
	my @out;

	while ($n >= $p * $p) {
		while ($n % $p == 0) {
			push @out, $p;
			$n /= $p;
		}
		$p = next_prime($p);
	}
	push @out, $n if $n > 1 || !@out;
	@out;
}

sub next_prime {
	my $p = shift;
	do { $p = $p == 2 ? 3 : $p + 2 } until is_prime($p);
	$p;
}

my %pcache;
sub is_prime {
	my $x = shift;
	$pcache{$x} //=	(factors($x) == 1)
}

sub mtest {
	my @bits = split "", sprintf("%b", shift);
	my $p = shift;
	my $sq = 1;
	while (@bits) {
		$sq = $sq * $sq;
		$sq *= 2 if shift @bits;
		$sq %= $p;
	}
	$sq == 1;
}

for my $m (2 .. 60, 929) {
	next unless is_prime($m);
	use bigint;

	my ($f, $k, $x) = (0, 0, 2**$m - 1);

	my $q;
	while (++$k) {
		$q = 2 * $k * $m + 1;
		next if (($q & 7) != 1 && ($q & 7) != 7);
		next unless is_prime($q);
		last if $q * $q > $x;
		last if $f = mtest($m, $q);
	}

	print $f? "M$m = $x = $q × @{[$x / $q]}\n"
		: "M$m = $x is prime\n";
}
