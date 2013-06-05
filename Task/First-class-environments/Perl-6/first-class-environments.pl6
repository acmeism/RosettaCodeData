my $calculator = sub ($n is rw) {
    return ($n == 1) ?? 1 !! $n %% 2 ?? $n div 2 !! $n * 3 + 1
};

sub next (%this is rw, &get_next) {
    return %this if %this.<value> == 1;
    %this.<value>.=&get_next;
    %this.<count>++;
    return %this;
};

my @hailstones = map { $_ = %(value => $_, count => 0) }, 1 .. 12;

while not all( map { $_.<value> }, @hailstones ) == 1 {
    say [~] map { $_.<value>.fmt("%4s") }, @hailstones;
    @hailstones[$_].=&next($calculator) for ^@hailstones;
}

say 'Counts';

say [~] map { $_.<count>.fmt("%4s") }, @hailstones;
