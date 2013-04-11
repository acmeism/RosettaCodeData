sub maxsubseq (*@a) {
    my ($start, $end, $sum, $maxsum) = -1, -1, 0, 0;
    for @a.kv -> $i, $x {
        $sum += $x;
        if $maxsum < $sum {
            ($maxsum, $end) = $sum, $i;
        }
        elsif $sum < 0 {
            ($sum, $start) = 0, $i;
        }
    }
    return @a[$start ^.. $end];
}
