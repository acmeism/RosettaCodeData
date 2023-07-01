use Math::Primesieve;
use Base::Any;

my $chars = 4;
my $check-base = 62;
my $threshold = $check-base ** $chars + 20;

my $sieve = Math::Primesieve.new;
my @primes = $sieve.primes($threshold);

my %prime-base;

%prime-base.push: $_ for (2..$check-base).map: -> $base {
    $threshold = (($base - 1).&to-base($base) x $chars).&from-base($base);
    @primes[^(@primes.first: * > $threshold, :k)].race.map: { .&to-base($base) => $base }
}

%prime-base.=grep: +*.value.elems > 10;

for 1 .. $chars -> $m {
    say "$m character strings that are prime in maximum bases: " ~ (my $e = ((%prime-base.grep( *.key.chars == $m )).max: +*.value.elems).value.elems);
    .say for %prime-base.grep( +*.value.elems == $e ).grep(*.key.chars == $m).sort: *.key;
    say '';
}
