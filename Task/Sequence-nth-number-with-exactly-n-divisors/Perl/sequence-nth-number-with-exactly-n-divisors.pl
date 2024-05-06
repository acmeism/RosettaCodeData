use strict;
use warnings;
use bigint;
use ntheory <nth_prime is_prime divisors>;

my $limit = 20;

print "First $limit terms of OEIS:A073916\n";

for my $n (1..$limit) {
    if ($n > 4 and is_prime($n)) {
        print nth_prime($n)**($n-1) . ' ';
    } else {
        my $i = my $x = 0;
        while (1) {
            my $nn = $n%2 ? ++$x**2 : ++$x;
            next unless $n == divisors($nn) and ++$i == $n;
            print "$nn " and last;
      }
    }
}
