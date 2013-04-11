sub counting-sort (@ints) {
    my $off = @ints.min;
    (my @counts)[$_ - $off]++ for @ints;
    @counts.kv.map: { ($^k + $off) xx ($^v // 0) }
}
