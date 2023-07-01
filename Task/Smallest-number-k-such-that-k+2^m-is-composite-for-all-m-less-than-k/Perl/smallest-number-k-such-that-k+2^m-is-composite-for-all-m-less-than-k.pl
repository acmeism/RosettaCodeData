use strict;
use warnings;
use bigint;
use ntheory 'is_prime';

my $cnt;
LOOP: for my $k (2..1e10) {
    next unless 1 == $k % 2;
    for my $m (1..$k-1) {
        next LOOP if is_prime $k + (1<<$m)
    }
    print "$k ";
    last if ++$cnt == 5;
}
