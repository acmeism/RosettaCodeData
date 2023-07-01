my @ones = flat 'th', 'st', 'nd', 'rd', 'th' xx 6;
my @teens = 'th' xx 10;
my @suffix = lazy flat (@ones, @teens, @ones xx 8) xx *;

# brute force the first six
for 1 .. 6 -> $sailors { for $sailors .. * -> $coconuts { last if check( $sailors, $coconuts ) } }

# finesse 7 through 15
for 7 .. 15 -> $sailors { next if check( $sailors, coconuts( $sailors ) ) }

sub is_valid ( $sailors is copy, $nuts is copy ) {
    return 0, 0 if $sailors == $nuts == 1;
    my @shares;
    for ^$sailors {
        return () unless $nuts % $sailors == 1;
        push @shares, ($nuts - 1) div $sailors;
        $nuts -= (1 + $nuts div $sailors);
    }
    push @shares, $nuts div $sailors;
    return @shares if !?($nuts % $sailors);
}

sub check ($sailors, $coconuts) {
    if my @piles = is_valid($sailors, $coconuts) {
        say "\nSailors $sailors: Coconuts $coconuts:";
        for ^(@piles - 1) -> $k {
             say "{$k+1}@suffix[$k+1] takes @piles[$k], gives 1 to the monkey."
        }
        say "The next morning, each sailor takes @piles[*-1]\nwith none left over for the monkey.";
        return True;
    }
    False;
}

multi sub coconuts ( $sailors where { $sailors % 2 == 0 } ) { ($sailors - 1) * ($sailors ** $sailors - 1) }
multi sub coconuts ( $sailors where { $sailors % 2 == 1 } ) { $sailors ** $sailors - $sailors + 1 }
