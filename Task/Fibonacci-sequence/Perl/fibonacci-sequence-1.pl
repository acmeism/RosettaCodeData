sub fibIter {
    my $n = shift;
    return $n if $n < 2;

    my $fibPrev = 1;
    my $fib = 1;
    ($fibPrev, $fib) = ($fib, $fib + $fibPrev) for 2..$n-1;
    $fib;
}
