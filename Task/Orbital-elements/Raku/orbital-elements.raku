sub orbital-state-vectors(
    Real :$semimajor-axis where * >= 0,
    Real :$eccentricity   where * >= 0,
    Real :$inclination,
    Real :$longitude-of-ascending-node,
    Real :$argument-of-periapsis,
    Real :$true-anomaly
) {
    use Clifford;
    my ($i, $j, $k) = @e[^3];

    sub rotate($a is rw, $b is rw, Real \α) {
        ($a, $b) = cos(α)*$a + sin(α)*$b, -sin(α)*$a + cos(α)*$b;
    }
    rotate($i, $j, $longitude-of-ascending-node);
    rotate($j, $k, $inclination);
    rotate($i, $j, $argument-of-periapsis);

    my \l = $eccentricity == 1 ?? # PARABOLIC CASE
        2*$semimajor-axis !!
        $semimajor-axis*(1 - $eccentricity**2);

    my ($c, $s) = .cos, .sin given $true-anomaly;

    my \r = l/(1 + $eccentricity*$c);
    my \rprime = $s*r**2/l;

    my $position = r*($c*$i + $s*$j);

    my $speed =
    (rprime*$c - r*$s)*$i + (rprime*$s + r*$c)*$j;
    $speed /= sqrt($speed**2);
    $speed *= sqrt(2/r - 1/$semimajor-axis);

    { :$position, :$speed }
}

say orbital-state-vectors
    semimajor-axis => 1,
    eccentricity => 0.1,
    inclination => pi/18,
    longitude-of-ascending-node => pi/6,
    argument-of-periapsis => pi/4,
    true-anomaly => 0;
