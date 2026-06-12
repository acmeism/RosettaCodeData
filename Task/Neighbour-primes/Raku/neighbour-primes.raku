my @primes = grep &is-prime, ^Inf;
my $last_p = @primes.first: :k, * >= 500;
my $last_q = $last_p + 1;

my @cousins = @primes.head( $last_q )
                     .rotor( 2 => -1 )
                     .map(-> (\p, \q) { p, q, p*q+2 } )
                     .grep( *.[2].is-prime );

say .fmt('%6d') for @cousins;
