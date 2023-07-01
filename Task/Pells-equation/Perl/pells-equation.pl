sub solve_pell {
    my ($n) = @_;

    use bigint try => 'GMP';

    my $x = int(sqrt($n));
    my $y = $x;
    my $z = 1;
    my $r = 2 * $x;

    my ($e1, $e2) = (1, 0);
    my ($f1, $f2) = (0, 1);

    for (; ;) {

        $y = $r * $z - $y;
        $z = int(($n - $y * $y) / $z);
        $r = int(($x + $y) / $z);

        ($e1, $e2) = ($e2, $r * $e2 + $e1);
        ($f1, $f2) = ($f2, $r * $f2 + $f1);

        my $A = $e2 + $x * $f2;
        my $B = $f2;

        if ($A**2 - $n * $B**2 == 1) {
            return ($A, $B);
        }
    }
}

foreach my $n (61, 109, 181, 277) {
    my ($x, $y) = solve_pell($n);
    printf("x^2 - %3d*y^2 = 1 for x = %-21s and y = %s\n", $n, $x, $y);
}
