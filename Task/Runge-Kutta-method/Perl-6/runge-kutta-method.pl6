sub runge-kutta(&yp) {
    return -> \t, \y, \δt {
        my $a = δt * yp( t, y );
        my $b = δt * yp( t + δt/2, y + $a/2 );
        my $c = δt * yp( t + δt/2, y + $b/2 );
        my $d = δt * yp( t + δt, y + $c );
        ($a + 2*($b + $c) + $d) / 6;
    }
}

constant δt = .1;
my &δy = runge-kutta { $^t * sqrt($^y) };

loop (
    my ($t, $y) = (0, 1);
    $t <= 10;
    ($t, $y) = ($t + δt, $y + δy($t, $y, δt))
) {
    printf "y(%2d) = %12f ± %e\n", $t, $y, abs($y - ($t**2 + 4)**2 / 16)
    if $t.narrow ~~ Int;
}
