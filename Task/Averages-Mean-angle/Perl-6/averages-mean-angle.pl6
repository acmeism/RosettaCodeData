# Of course, you can still use pi and 180.
sub deg2rad { $^d * tau / 360 }
sub rad2deg { $^r * 360 / tau }

sub phase ($c)  {
    my ($mag,$ang) = $c.polar;
    return NaN if $mag < 1e-16;
    $ang;
}

sub meanAngle { rad2deg phase [+] map { cis deg2rad $_ }, @^angles }

say meanAngle($_).fmt("%.2f\tis the mean angle of "), $_ for
    [350, 10],
    [90, 180, 270, 360],
    [10, 20, 30];
