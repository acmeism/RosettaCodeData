sub find ($matcher, $container) {
    for $container.kv -> $k, $v {
        $v ~~ $matcher and return $k;
    }
    fail 'No values matched';
}

my Str @haystack = <Zig Zag Wally Ronald Bush Krusty Charlie Bush Bozo>;

for <Washingston Bush> -> $needle {
    my $pos = find $needle, @haystack;
    if defined $pos {
        say "Found '$needle' at index $pos";
        say 'Largest index: ', @haystack.end -
            find { $needle eq $^x }, reverse @haystack;
    }
    else {
        say "'$needle' not in haystack";
    }
}
