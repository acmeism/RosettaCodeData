package Hailstone;

sub seq {
	my $x = shift;
	$x == 1	? (1) : ($x & 1)? ($x, seq($x * 3 + 1))
				: ($x, seq($x / 2))
}

my %cache = (1 => 1);
sub len {
	my $x = shift;
	$cache{$x} //= 1 + (
		$x & 1	? len($x * 3 + 1)
			: len($x / 2))
}

unless (caller) {
    for (1 .. 100_000) {
        my $l = len($_);
        ($m, $len) = ($_, $l) if $l > $len;
    }
    print "seq of 27 - $cache{27} elements: @{[seq(27)]}\n";
    print "Longest sequence is for $m: $len\n";
}

1;
