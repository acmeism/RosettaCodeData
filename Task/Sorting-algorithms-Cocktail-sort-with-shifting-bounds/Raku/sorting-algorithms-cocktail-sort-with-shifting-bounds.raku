sub cocktail_sort ( @a ) {
    my ($min, $max) = 0, +@a - 2;
    loop {
        my $swapped_forward = 0;
        for $min .. $max -> $i {
            given @a[$i] cmp @a[$i+1] {
                when More {
                    @a[ $i, $i+1 ] .= reverse;
                    $swapped_forward = 1
                }
                default {}
            }
        }
        last if not $swapped_forward;
        $max -= 1;

        my $swapped_backward = 0;
        for ($min .. $max).reverse -> $i {
            given @a[$i] cmp @a[$i+1] {
                when More {
                    @a[ $i, $i+1 ] .= reverse;
                    $swapped_backward = 1
                }
                default {}
            }
        }
        last if not $swapped_backward;
        $min += 1;
    }
    @a
}

my @weights = (flat 0..9, 'A'..'F').roll(2 + ^4 .roll).join xx 100;
say @weights.sort.Str eq @weights.&cocktail_sort.Str ?? 'ok' !! 'not ok';
