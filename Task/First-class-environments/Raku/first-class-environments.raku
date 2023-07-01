my $calculator = sub ($n is rw) {
    $n == 1 ?? 1 !! $n %% 2 ?? $n div 2 !! $n * 3 + 1
}

sub next (%this, &get_next) {
    return %this if %this.<value> == 1;
    %this.<value> .= &get_next;
    %this.<count>++;
    %this;
}

my @hailstones = map { %(value => $_, count => 0) }, 1 .. 12;

while not all( map { $_.<value> }, @hailstones ) == 1 {
    say [~] map { $_.<value>.fmt: '%4s' }, @hailstones;
    @hailstones[$_] .= &next($calculator) for ^@hailstones;
}

say "\nCounts\n" ~ [~] map { $_.<count>.fmt: '%4s' }, @hailstones;
