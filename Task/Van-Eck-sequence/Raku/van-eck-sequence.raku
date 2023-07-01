sub n-van-ecks ($init) {
    $init, -> $i, {
        state %v;
        state $k;
        $k++;
        my $t  = %v{$i}.defined ?? $k - %v{$i} !! 0;
        %v{$i} = $k;
        $t
    } ... *
}

for <
    A181391 0
    A171911 1
    A171912 2
    A171913 3
    A171914 4
    A171915 5
    A171916 6
    A171917 7
    A171918 8
> -> $seq, $start {

    my @seq = n-van-ecks($start);

    # The task
    put qq:to/END/

    Van Eck sequence OEIS:$seq; with the first term: $start
            First 10 terms: {@seq[^10]}
    Terms 991 through 1000: {@seq[990..999]}
    END
}
