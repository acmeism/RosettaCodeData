my @sets = [1, 2, 1],
           [1, 2, 3],
           [1, -2, 1],
           [1, 0, -4],
           [1, -10**6, 1];

for @sets -> @coefficients {
    say "Roots for @coefficients.join(', ').fmt("%-16s")",
        "=> (&quadroots( @coefficients ).join(', '))";
}

multi sub quadroots ($a, $b, $c) {
    my $root = (my $t = $b ** 2 - 4 * $a * $c ) < 0
        ?? $t.Complex.sqrt
        !! $t.sqrt;
    return ( -$b + $root ) / (2 * $a),
           ( -$b - $root ) / (2 * $a);
}

multi sub quadroots (@a) {
    @a == 3 or die "Expected three elements, got {+@a}";
    quadroots |@a;
}
