sub counting-sort (@ints) {
    my $off = @ints.min;
    (my @counts)[$_ - $off]++ for @ints;
    flat @counts.kv.map: { ($^k + $off) xx ($^v // 0) }
}

# Testing:
constant @age-range = 2 .. 102;
my @ages = @age-range.roll(50);
say @ages.&counting-sort;
say @ages.sort;

say @ages.&counting-sort.join eq @ages.sort.join ?? 'ok' !! 'not ok';
