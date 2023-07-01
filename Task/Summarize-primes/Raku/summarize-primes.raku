use Lingua::EN::Numbers;

my @primes    = grep *.is-prime, ^Inf;
my @primesums = [\+] @primes;
say "{.elems} cumulative prime sums:\n",
    .map( -> $p {
        sprintf "The sum of the first %3d (up to {@primes[$p]}) is prime: %s",
        1 + $p, comma @primesums[$p]
      }
    ).join("\n")
    given grep { @primesums[$_].is-prime }, ^1000;
