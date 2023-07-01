use ntheory:from<Perl5> <is_prime>;

for 3 .. 11 -> $base {
    say "Starting base $base...";
    my @stems = grep { .is-prime }, ^$base;
    for 1 .. * -> $digits {
        print ' ', @stems.elems;
        my @new;
        my $place = $base ** $digits;
        for 1 ..^ $base -> $digit {
            my $left = $digit * $place;
            @new.append: (@stems »+» $left).grep: { is_prime("$_") }
        }
        last unless +@new;
        @stems = @new;
    }
    say "\nLargest ltp in base $base = {@stems.max} or :$base\<@stems.max.base($base)}>\n";
}
