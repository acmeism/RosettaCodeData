constant TRIALS = 1e6;

constant @event = <aleph beth gimel daleth he waw zayin heth>;

constant @P = flat (1 X/ 5 .. 11), 1759/27720;
constant @cP = [\+] @P;

my @results;
@results[ @cP.first: { $_ > once rand }, :k ]++ xx TRIALS;

say  'Event    Occurred Expected  Difference';
for ^@results {
    my ($occurred, $expected) = @results[$_], @P[$_] * TRIALS;
    printf "%-9s%8.0f%9.1f%12.1f\n",
            @event[$_],
                $occurred,
                     $expected,
                          abs $occurred - $expected;
}
