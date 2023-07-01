use strict;
use warnings;
use ntheory qw/factorial/;

for my $n (100, 1000, 10000) {
    my($sum,$f) = 0;
    $f = factorial $_ and $sum += ($f =~ tr/0//) / length $f for 1..$n;
    printf "%5d: %.5f\n", $n, $sum/$n;
}
