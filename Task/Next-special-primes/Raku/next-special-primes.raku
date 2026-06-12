sub is-special ( ($previous, $gap) ) {
    state @primes = grep *.is-prime, 2..*;
    shift @primes while @primes[0] <= $previous + $gap;
    return ( @primes[0], @primes[0] - $previous );
}

my @specials = (2, 0), &is-special … *;

my $limit = @specials.first: :k, *.[0] > 1050;

say .fmt('%4d') for @specials.head($limit);
