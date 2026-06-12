use Math::Primesieve;
my $sieve = Math::Primesieve.new;
say sum $sieve.primes(2e6.Int);
