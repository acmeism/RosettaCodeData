use Math::Primesieve;

my %conspiracy;
my $upto = 1_000_000;
my $sieve = Math::Primesieve.new;
my @primes = $sieve.n-primes($upto+1);

@primes[^($upto+1)].reduce: -> $a, $b {
    my $d = $b % 10;
    %conspiracy{"$a → $d count:"}++;
    $d;
}

say "$_ \tfrequency: {($_.value/$upto*100).round(.01)} %" for %conspiracy.sort;
