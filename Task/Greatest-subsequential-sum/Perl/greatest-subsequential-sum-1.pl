use strict;

sub max_sub(\@) {
	my ($a, $maxs, $maxe, $s, $sum, $maxsum) = shift;
	foreach (0 .. $#$a) {
		my $t = $sum + $a->[$_];
		($s, $sum) = $t > 0 ? ($s, $t) : ($_ + 1, 0);

		if ($maxsum < $sum) {
			$maxsum = $sum;
			($maxs, $maxe) = ($s, $_ + 1)
		}
	}
	@$a[$maxs .. $maxe - 1]
}

my @a = map { int(rand(20) - 10) } 1 .. 10;
my @b = (-1) x 10;

print "seq: @a\nmax: [ @{[max_sub @a]} ]\n";
print "seq: @b\nmax: [ @{[max_sub @b]} ]\n";
