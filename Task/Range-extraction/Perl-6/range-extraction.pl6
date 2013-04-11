sub range-extraction (*@ints) {
    my $prev = NaN;
    my @ranges;

    for @ints -> $int {
        if $int == $prev + 1 {
            @ranges[*-1].push: $int;
        }
        else {
            @ranges.push: [$int];
        }
        $prev = $int;
    }
    join ',', @ranges.map: -> @r { @r > 2 ?? "@r[0]-@r[*-1]" !! @r }
}

say range-extraction
    -6, -3, -2, -1, 0, 1, 3, 4, 5, 7, 8, 9, 10, 11, 14, 15, 17, 18, 19, 20;

say range-extraction
    0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
    25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
    37, 38, 39;
