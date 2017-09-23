for 3 .. * -> $base {
    say "Starting base $base...";
    my @stems = grep { .is-prime }, ^$base;
    for 1 .. * -> $digits {
        print ' ', @stems.elems;
        my @new;
        my $place = $base ** $digits;
        for 1 ..^ $base -> $digit {
            my $left = $digit * $place;
            for @stems -> $stem {
	        my $new = $left + $stem;
	        @new.push($new) if $new.is-prime;
            }
        }
        last unless @new;
        @stems = @new;
    }
    say "\nLargest ltp in base $base = { @stems.tail } or :$base\<{@stems.tail.base($base)}>\n";
}
