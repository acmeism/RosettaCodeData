sub cocktail_sort ( @a ) {
    my $range = 0 ..^ @a.end;
    loop {
        my $swapped_forward = 0;
        for $range.list -> $i {
            if @a[$i] > @a[$i+1] {
                @a[ $i, $i+1 ] .= reverse;
                $swapped_forward = 1;
            }
        }
        last if not $swapped_forward;

        my $swapped_backward = 0;
        for $range.reverse -> $i {
            if @a[$i] > @a[$i+1] {
                @a[ $i, $i+1 ] .= reverse;
                $swapped_backward = 1;
            }
        }
        last if not $swapped_backward;
    }
    return @a;
}

my @weights = (^50).map: { 100 + ( 1000.rand.Int / 10 ) };
say @weights.sort.Str eq @weights.&cocktail_sort.Str ?? 'ok' !! 'not ok';
