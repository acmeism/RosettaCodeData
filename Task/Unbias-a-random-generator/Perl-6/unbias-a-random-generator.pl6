sub randN ( $n where 3..6 ) {
    return ( $n.rand / ($n - 1) ).Int;
}

sub unbiased ( $n where 3..6 ) {
    my $n1;
    repeat { $n1 = randN($n) } until $n1 != randN($n);
    return $n1;
}

my $iterations = 1000;
for 3 .. 6 -> $n {
    my ( @raw, @fixed );
    for ^$iterations {
        @raw[      randN($n) ]++;
        @fixed[ unbiased($n) ]++;
    }
    printf "N=%d   randN: %s, %4.1f%%   unbiased: %s, %4.1f%%\n",
        $n, map { .perl, .[1] * 100 / $iterations }, @raw, @fixed;
}
