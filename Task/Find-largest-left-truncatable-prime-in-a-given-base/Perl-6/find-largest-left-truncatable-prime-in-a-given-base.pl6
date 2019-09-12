for 3 .. * -> $base {
    say "Starting base $base...";
    my @stems = grep { .is-prime }, ^$base;
    for 1 .. * -> $digits {
        print ' ', @stems.elems;
        my @new;
        my $place = $base ** $digits;
        for 1 ..^ $base -> $digit {
            my $left = $digit * $place;
            @new.append: (@stems »+» $left).race(:8degree, :8batch).grep: *.is-prime
        }
        last unless +@new;
        @stems = @new;
    }
    say "\nLargest ltp in base $base = {@stems.max} or :$base\<@stems.max.base($base)}>\n";
}
