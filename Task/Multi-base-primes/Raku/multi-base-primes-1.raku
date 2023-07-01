use Math::Primesieve;
my $sieve = Math::Primesieve.new;

my %prime-base;

my $chars = 4; # for demonstration purposes. Change to 5 for the whole shmegegge.

my $threshold = ('1' ~ 'Z' x $chars).parse-base(36);

my @primes = $sieve.primes($threshold);

%prime-base.push: $_ for (2..36).map: -> $base {
    $threshold = (($base - 1).base($base) x $chars).parse-base($base);
    @primes[^(@primes.first: * > $threshold, :k)].race.map: { .base($base) => $base }
}

%prime-base.=grep: +*.value.elems > 10;

for 1 .. $chars -> $m {
    say "$m character strings that are prime in maximum bases: " ~ (my $e = ((%prime-base.grep( *.key.chars == $m )).max: +*.value.elems).value.elems);
    .say for %prime-base.grep( +*.value.elems == $e ).grep(*.key.chars == $m).sort: *.key;
    say '';
}
