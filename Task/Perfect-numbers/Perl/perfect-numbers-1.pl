sub perf {
    my $n = shift;
    my $sum = 0;
    foreach my $i (1..$n-1) {
        if ($n % $i == 0) {
            $sum += $i;
        }
    }
    return $sum == $n;
}
