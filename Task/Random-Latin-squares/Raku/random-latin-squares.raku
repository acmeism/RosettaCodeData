sub latin-square { [[0],] };

sub random ( @ls, :$size = 5 ) {

    # Build
    for 1 ..^ $size -> $i {
        @ls[$i] = @ls[0].clone;
        @ls[$_].splice($_, 0, $i) for 0 .. $i;
    }

    # Shuffle
    @ls = @ls[^$size .pick(*)];
    my @cols = ^$size .pick(*);
    @ls[$_] = @ls[$_][@cols] for ^@ls;

    # Some random Latin glyphs
    my @symbols = ('A' .. 'Z').pick($size);

    @ls.deepmap: { $_ = @symbols[$_] };

}

sub display ( @array ) { $_.fmt("%2s ").put for |@array, '' }


# The Task

# Default size 5
display random latin-square;

# Specified size
display random :size($_), latin-square for 5, 3, 9;

# Or, if you'd prefer:
display random latin-square, :size($_) for 12, 2, 1;
