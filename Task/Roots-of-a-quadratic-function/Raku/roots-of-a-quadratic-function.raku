for
[1, 2, 1],
[1, 2, 3],
[1, -2, 1],
[1, 0, -4],
[1, -10⁶, 1]
-> @coefficients {
    printf "Roots for %d, %d, %d\t=> (%s, %s)\n",
    |@coefficients, |quadroots(@coefficients);
}

sub quadroots (*[$a, $b, $c]) {
    ( -$b + $_ ) / (2 × $a),
    ( -$b - $_ ) / (2 × $a)
    given
    ($b² - 4 × $a × $c ).Complex.sqrt.narrow
}
