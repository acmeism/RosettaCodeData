sub fibonacci {
    my $n = shift;

    return 0 if $n <  1;
    return 1 if $n == 1;

    my @numbers = (0, 1);

    push @numbers, $numbers[-1] + $numbers[-2] foreach 2 .. $n;

    return $numbers[-1];
}

print "Fibonacci($_) -> ", (fibonacci $_), "\n"
    foreach (0 .. 20, 50, 93, 94, 100, 200, 1000, 1476, 1477);
