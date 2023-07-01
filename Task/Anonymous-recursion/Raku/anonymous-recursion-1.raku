sub fib($n) {
    die "Naughty fib" if $n < 0;
    return {
        $_ < 2
            ?? $_
            !!  &?BLOCK($_-1) + &?BLOCK($_-2);
    }($n);
}

say fib(10);
