use Math::Primesieve;

my $sieve = Math::Primesieve.new;

say "10^$_\t" ~ $sieve.count: exp($_,10) for ^10;

say (now - INIT now) ~ ' elapsed seconds';
