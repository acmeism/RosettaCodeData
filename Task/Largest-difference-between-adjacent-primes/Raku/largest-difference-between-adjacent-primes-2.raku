use Math::Primesieve;
my $sieve = Math::Primesieve.new;

for 2..8 -> $n {
    printf "Largest prime gap up to {10 ** $n}: %d - between %d and %d.\n", .[0], |.[1]
      given max $sieve.primes(10 ** $n).rotor(2=>-1).map({.[1]-.[0],$_})
}
