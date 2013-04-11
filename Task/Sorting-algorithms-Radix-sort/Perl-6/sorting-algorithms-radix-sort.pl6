sub radsort (@ints) {
    my $maxlen = [max] @ints».chars;
    my @list = @ints».fmt("\%0{$maxlen}d");

    for reverse ^$maxlen -> $r {
        my @buckets = @list.classify( *.substr($r,1) ).sort: *.key;
        if !$r and @buckets[0].key eq '-' { @buckets[0].value .= reverse }
        @list = map *.value.values, @buckets;
    }
    @list».Int;
}

.say for radsort (-2_000 .. 2_000).roll(20);
