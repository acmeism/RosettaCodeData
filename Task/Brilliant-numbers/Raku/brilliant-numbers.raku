use Lingua::EN::Numbers;

# Find an abundance of primes to use to generate brilliants
my %primes = (2..100000).grep( &is-prime ).categorize: { .chars };

# Generate brilliant numbers
my @brilliant = lazy flat (1..*).map: -> $digits {
    sort flat (^%primes{$digits}).race.map: { %primes{$digits}[$_] X× (flat %primes{$digits}[$_ .. *]) }
};

# The task
put "First 100 brilliant numbers:\n" ~ @brilliant[^100].batch(10)».fmt("%4d").join("\n") ~ "\n" ;

for 1 .. 7 -> $oom {
    my $threshold = exp $oom, 10;
    my $key = @brilliant.first: :k, * >= $threshold;
    printf "First >= %13s is %9s in the series: %13s\n", comma($threshold), ordinal-digit(1 + $key, :u), comma @brilliant[$key];
}
