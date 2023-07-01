use Math::Primesieve;

my $sieve = Math::Primesieve.new;
my @primes = $sieve.primes(10_000_000);

sub primorial($n) { [*] @primes[^$n] }

say "First ten primorials: {(primorial $_ for ^10)}";
say "primorial(10^$_) has {primorial(10**$_).chars} digits" for 1..5;
