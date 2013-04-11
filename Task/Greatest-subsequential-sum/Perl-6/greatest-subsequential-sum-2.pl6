sub max_sub-seq ( *@a ) {

    my $max_subset = [];
    while @a {
        my @subsets = @a.keys.map: { [ @a[0..$_] ] };
        @subsets.push($max_subset);
        $max_subset = @subsets.max: { [+] .list };
        @a.shift;
    }

    return $max_subset;
}

max_sub-seq( -1, -2,  3,  5,  6, -2, -1,  4, -4,  2, -1 ).perl.say;
max_sub-seq( -2, -2, -1,  3,  5,  6, -1,  4, -4,  2, -1 ).perl.say;
max_sub-seq( -2, -2, -1, -3, -5, -6, -1, -4, -4, -2, -1 ).perl.say;
