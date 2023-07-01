my Str @haystack = <Zig Zag Wally Ronald Bush Krusty Charlie Bush Bozo>;

for <Washingston Bush> -> $needle {
    my $first = @haystack.first($needle, :k);

    if defined $first {
        my $last = @haystack.first($needle, :k, :end);
        say "$needle -- first at $first, last at $last";
    }
    else {
        say "$needle -- not in haystack";
    }
}
