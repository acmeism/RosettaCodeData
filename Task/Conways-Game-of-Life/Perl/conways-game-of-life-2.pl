my $w = `tput cols` - 1;
my $h = `tput lines` - 1;
my $r = "\033[H";

my @universe = map([ map(rand(1) < .1, 1 .. $w) ], 1 .. $h);
sub iterate {
	my @new = map([ map(0, 1 .. $w) ], 1 .. $h);
	for my $i (0 .. $h - 1) {
	for my $j (0 .. $w - 1) {
		my $neighbor = 0;
		for (	[-1, -1], [-1, 0], [-1, 1],
			[ 0, -1], 	   [ 0, 1],
			[ 1, -1], [ 1, 0], [ 1, 1] )
		{
			my $y = $_->[0] + $i;
			my $x = $_->[1] + $j;
			$neighbor += $universe[$y % $h][$x % $w];
			last if $neighbor > 3;
		}

		$new[$i][$j] = $universe[$i][$j]
			? ($neighbor == 2 or $neighbor == 3)
			: $neighbor == 3;
	}}
	@universe = @new;
}

while(1) {
	print $r;
	print map((map($_ ? "#" : " ", @$_), "\n"), @universe);
	iterate;
}
