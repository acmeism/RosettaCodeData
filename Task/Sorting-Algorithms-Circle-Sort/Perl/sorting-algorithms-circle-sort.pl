sub circlesort {
    our @x; local *x = shift;
    my($beg,$end) = @_;

    my $swaps = 0;
    if ($beg < $end) {
        my $lo = $beg;
        my $hi = $end;
        while ($lo < $hi) {
            if ($x[$lo] > $x[$hi]) { # 'gt' here for string comparison
                @x[$lo,$hi] = @x[$hi,$lo];
                ++$swaps;
            }
            ++$hi if --$hi == ++$lo
        }
        $swaps += circlesort(\@x, $beg, $hi);
        $swaps += circlesort(\@x, $lo, $end);
    }
    $swaps;
}

my @a = <16 35 -64 -29 46 36 -1 -99 20 100 59 26 76 -78 39 85 -7 -81 25 88>;
while (circlesort(\@a, 0, $#a)) { print join(' ', @a), "\n" }
