use 5.10.0;
use List::Util 'max';

my @sum;
while (<>) {
	my @x = split;
	@sum = ($x[0] + $sum[0],
		map($x[$_] + max(@sum[$_-1, $_]), 1 .. @x-2),
		$x[-1] + $sum[-1]);
}

say max(@sum);
