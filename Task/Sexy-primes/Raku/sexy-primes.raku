use Math::Primesieve;
my $sieve = Math::Primesieve.new;

my $max = 1_000_035;
my @primes = $sieve.primes($max);

my $filter = @primes.Set;
my $primes = @primes.categorize: &sexy;

say "Total primes less than {comma $max}: ", comma +@primes;

for <pair 2 triplet 3 quadruplet 4 quintuplet 5> -> $sexy, $cnt {
    say "Number of sexy prime {$sexy}s less than {comma $max}: ", comma +$primes{$sexy};
    say "   Last 5 sexy prime {$sexy}s less than {comma $max}: ",
      join ' ', $primes{$sexy}.tail(5).grep(*.defined).map:
      { "({ $_ «+« (0,6 … 24)[^$cnt] })" }
    say '';
}

say "Number of unsexy primes less than {comma $max}: ", comma +$primes<unsexy>;
say "  Last 10 unsexy primes less than {comma $max}: ", $primes<unsexy>.tail(10);

sub sexy ($i) {
    gather {
        take 'quintuplet' if all($filter{$i «+« (6,12,18,24)});
        take 'quadruplet' if all($filter{$i «+« (6,12,18)});
        take 'triplet'    if all($filter{$i «+« (6,12)});
        take 'pair'       if $filter{$i + 6};
        take (($i >= $max - 6) && ($i + 6).is-prime) ||
          (so any($filter{$i «+« (6, -6)})) ?? 'sexy' !! 'unsexy';
    }
}

sub comma { $^i.flip.comb(3).join(',').flip }
