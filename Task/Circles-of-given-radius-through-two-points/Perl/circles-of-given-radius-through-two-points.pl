use strict;

sub circles {
    my ($x1, $y1, $x2, $y2, $r) = @_;

    return "Radius is zero" if $r == 0;
    return "Coincident points gives infinite number of circles" if $x1 == $x2 and $y1 == $y2;

    # delta x, delta y between points
    my ($dx, $dy) = ($x2 - $x1, $y2 - $y1);
    my $q = sqrt($dx**2 + $dy**2);
    return "Separation of points greater than diameter" if $q > 2*$r;

    # halfway point
    my ($x3, $y3) = (($x1 + $x2) / 2, ($y1 + $y2) / 2);
    # distance along the mirror line
    my $d = sqrt($r**2-($q/2)**2);

    # pair of solutions
    sprintf '(%.4f, %.4f) and (%.4f, %.4f)',
        $x3 - $d*$dy/$q, $y3 + $d*$dx/$q,
        $x3 + $d*$dy/$q, $y3 - $d*$dx/$q;
}

my @arr = (
    [0.1234, 0.9876, 0.8765, 0.2345, 2.0],
    [0.0000, 2.0000, 0.0000, 0.0000, 1.0],
    [0.1234, 0.9876, 0.1234, 0.9876, 2.0],
    [0.1234, 0.9876, 0.8765, 0.2345, 0.5],
    [0.1234, 0.9876, 0.1234, 0.9876, 0.0]
);

printf "(%.4f, %.4f) and (%.4f, %.4f) with radius %.1f: %s\n", @$_[0..4], circles @$_ for @arr;
