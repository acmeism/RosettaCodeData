sub max-subseq ( *@a ) {

    my $max-subset = ();
    while @a {
        my @subsets = [\,] @a;
        @subsets.push: $max-subset;
        $max-subset = @subsets.max: { [+] .list };
        @a.shift;
    }

    return $max-subset;
}

max-subseq( -1, -2,  3,  5,  6, -2, -1,  4, -4,  2, -1 ).say;
max-subseq( -2, -2, -1,  3,  5,  6, -1,  4, -4,  2, -1 ).say;
max-subseq( -2, -2, -1, -3, -5, -6, -1, -4, -4, -2, -1 ).say;
