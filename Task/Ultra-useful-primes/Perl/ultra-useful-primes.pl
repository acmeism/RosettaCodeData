use strict;
use warnings;
use feature 'say';
use bigint;
use ntheory 'is_prime';

sub useful {
    my @n = @_;
    my @u;
    for my $n (@n) {
        my $p = 2**(2**$n);
        LOOP: for (my $k = 1; $k < $p; $k += 2) {
            is_prime($p-$k) and push @u, $k and last LOOP;
       }
    }
    @u
}

say join ' ', useful 1..13;
