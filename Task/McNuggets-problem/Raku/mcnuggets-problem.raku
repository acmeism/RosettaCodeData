sub Mcnugget-number (*@counts) {

    return '∞' if 1 < [gcd] @counts;

    my $min = min @counts;
    my @meals;
    my @min;

    for ^Inf -> $a {
        for 0..$a -> $b {
            for 0..$b -> $c {
                ($a, $b, $c).permutations.map: { @meals[ sum $_ Z* @counts ] = True }
            }
        }
        for @meals.grep: so *, :k {
            if @min.tail and @min.tail + 1 == $_ {
                @min.push: $_;
                last if $min == +@min
            } else {
                @min = $_;
            }
        }
        last if $min == +@min
    }
    @min[0] ?? @min[0] - 1 !! 0
}

for (6,9,20), (6,7,20), (1,3,20), (10,5,18), (5,17,44), (2,4,6), (3,6,15) -> $counts {
    put "Maximum non-Mcnugget number using {$counts.join: ', '} is: ",
        Mcnugget-number(|$counts)
}
