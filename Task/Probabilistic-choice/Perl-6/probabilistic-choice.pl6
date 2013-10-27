constant TRIALS = 1e4;

my %ps = <aleph beth gimel daleth he waw zayin> Z=> 1 «/« (5 .. 11);
%ps<heth> = 1 - [+] values %ps;

my %results;
for ^TRIALS {
    %results{.key}++ given
    first { .value > state $ = rand },
    state % = %ps.keys Z=> [\+] %ps.values;
}

say 'Event   Occurred  Expected  Difference';
for sort *.value, %results {
    my ($occurred, $expected) = .value/TRIALS, %ps{.key};
    printf "%-6s  %f  %f  %f\n",
        .key, $occurred, $expected,
        abs( $occurred - $expected );
}
