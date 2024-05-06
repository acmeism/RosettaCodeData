use strict;
use warnings;
use ntheory 'divisors';

print "First 15 terms of OEIS: A005179\n";
for my $n (1..15) {
    my $l = 0;
    while (++$l) {
        print "$l " and last if $n == divisors($l);
    }
}
