sub circlesort (@x, $beg, $end) {
    my $swaps = 0;
    if $beg < $end {
        my ($lo, $hi) = $beg, $end;
        repeat {
            if @x[$lo] after @x[$hi] {
                @x[$lo,$hi] .= reverse;
                ++$swaps;
            }
            ++$hi if --$hi == ++$lo
        } while $lo < $hi;
        $swaps += circlesort(@x, $beg, $hi);
        $swaps += circlesort(@x, $lo, $end);
    }
    $swaps;
}

say my @x = (-100..100).roll(20);
say @x while circlesort(@x, 0, @x.end);

say @x = <The quick brown fox jumps over the lazy dog.>;
say @x while circlesort(@x, 0, @x.end);
