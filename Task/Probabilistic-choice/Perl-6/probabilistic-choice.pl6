constant TRIALS = 1e4;

my @event = <aleph beth gimel daleth he waw zayin heth>;

my @P = 1 «/« (5 .. 11), 1759/27720;
my @cP = [\+] @P;

my @results;
for ^TRIALS {
    @results[
	first { @cP[$_] > state $ = rand }, ^@P;
    ]++;
}

say  'Event    Occurred Expected  Difference';
for ^@results {
    my ($occurred, $expected) = @results[$_], @P[$_]*TRIALS;
    printf "%-9s%8.0f%9.1f%12.1f\n",
        @event[$_], $occurred, $expected,
        abs( $occurred - $expected );
}
