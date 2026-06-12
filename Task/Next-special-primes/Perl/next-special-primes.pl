use strict;
use warnings;
use feature <state say>;
use ntheory 'primes';

my $limit = 1050;

sub is_special {
    state $previous = 2;
    state $gap      = 0;
    state @primes = @{primes( 2*$limit )};

    shift @primes while $primes[0] <= $previous + $gap;
    $gap = $primes[0] - $previous;
    $previous = $primes[0];
    [$previous, $gap];
}

my @specials = [2, 0];
do { push @specials, is_special() } until $specials[-1][0] >= $limit;

pop @specials;
printf "%4d %4d\n", @$_ for @specials;
