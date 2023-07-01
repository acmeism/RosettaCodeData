sub comb_sort ( @a is copy ) {
    my $gap = +@a;
    my $swaps = 1;
    while $gap > 1 or $swaps {
        $gap = ( ($gap * 4) div 5 ) || 1 if $gap > 1;

        $swaps = 0;
        for ^(+@a - $gap) -> $i {
            my $j = $i + $gap;
            if @a[$i] > @a[$j] {
                @a[$i, $j] .= reverse;
                $swaps = 1;
            }
        }
    }
    return @a;
}

my @weights = (^50).map: { 100 + ( 1000.rand.Int / 10 ) };
say @weights.sort.Str eq @weights.&comb_sort.Str ?? 'ok' !! 'not ok';
