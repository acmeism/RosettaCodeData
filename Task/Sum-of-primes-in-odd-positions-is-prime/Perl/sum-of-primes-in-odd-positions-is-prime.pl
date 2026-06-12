use strict;
use warnings;
use ntheory 'is_prime';

my $c;
my @odd  = grep { 0 != ++$c % 2 } grep { is_prime $_ } 2 .. 999;
my @sums = $odd[0];
push @sums, $sums[-1] + $_ for @odd[1..$#odd];

$c = 1;
for (0..$#sums) {
    printf "%6d%6d%6d\n", $c, $odd[$_], $sums[$_] if is_prime $sums[$_];
    $c += 2;
}
