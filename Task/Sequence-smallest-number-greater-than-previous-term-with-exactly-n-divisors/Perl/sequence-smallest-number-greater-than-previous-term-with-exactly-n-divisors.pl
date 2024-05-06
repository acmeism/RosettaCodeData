use strict;
use warnings;
use ntheory 'divisors';

print "First 15 terms of OEIS: A069654\n";
my $m = 0;
for my $n (1..15) {
    my $l = $m;
    while (++$l) {
        print("$l "), $m = $l, last if $n == divisors($l);
    }
}
