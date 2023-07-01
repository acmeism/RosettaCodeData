use Math::Primesieve;
my $sieve = Math::Primesieve.new;

sub is-long (Int $p) {
    my $r = 1;
    my $rr = $r = (10 * $r) % $p for ^$p;
    my $period;
    loop {
        $r = (10 * $r) % $p;
        ++$period;
        last if $period >= $p or $r == $rr;
    }
    $period == $p - 1 and $p > 2;
}

my @primes = $sieve.primes(500);
my @long-primes = @primes.grep: {.&is-long};

put "Long primes ≤ 500:\n", @long-primes;

@long-primes = ();

for 500, 1000, 2000, 4000, 8000, 16000, 32000, 64000 -> $upto {
    state $from = 0;
    my @extend = $sieve.primes($from, $upto);
    @long-primes.append: @extend.hyper(:8degree).grep: {.&is-long};
    say "\nNumber of long primes ≤ $upto: ", +@long-primes;
    $from = $upto;
}
