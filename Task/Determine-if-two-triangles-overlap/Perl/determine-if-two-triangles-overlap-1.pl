use strict;
use warnings;

sub det2D {
    my $p1 = shift or die "4 Missing first point\n";
    my $p2 = shift or die "Missing second point\n";
    my $p3 = shift or die "Missing third point\n";

    return $p1->{x} * ($p2->{y} - $p3->{y})
         + $p2->{x} * ($p3->{y} - $p1->{y})
         + $p3->{x} * ($p1->{y} - $p2->{y});
}

sub checkTriWinding {
    my $p1 = shift or die "14 Missing first point\n";
    my $p2 = shift or die "Missing second point\n";
    my $p3 = shift or die "Missing third point\n";
    my $allowReversed = shift;

    my $detTri = det2D($p1, $$p2, $$p3);
    if ($detTri < 0.0) {
        if ($allowReversed) {
            my $t = $$p3;
            $$p3 = $$p2;
            $$p2 = $t;
        } else {
            die "triangle has wrong winding direction";
        }
    }
    return undef;
}

sub boundaryCollideChk {
    my $p1 = shift or die "33 Missing first point\n";
    my $p2 = shift or die "Missing second point\n";
    my $p3 = shift or die "Missing third point\n";
    my $eps = shift;

    return det2D($p1, $p2, $p3) < $eps;
}

sub boundaryDoesntCollideChk {
    my $p1 = shift or die "42 Missing first point\n";
    my $p2 = shift or die "Missing second point\n";
    my $p3 = shift or die "Missing third point\n";
    my $eps = shift;

    return det2D($p1, $p2, $p3) <= $eps;
}

sub triTri2D {
    my $t1 = shift or die "Missing first triangle to calculate with\n";
    my $t2 = shift or die "Missing second triangle to calculate with\n";
    my $eps = shift;
    my $allowReversed = shift;
    my $onBoundary = shift;

    # triangles must be expressed anti-clockwise
    checkTriWinding($t1->[0], \$t1->[1], \$t1->[2], $allowReversed);
    checkTriWinding($t2->[0], \$t2->[1], \$t2->[2], $allowReversed);

    my $chkEdge;
    if ($onBoundary) {
        # points on the boundary are considered as colliding
        $chkEdge = \&boundaryCollideChk;
    } else {
        # points on the boundary are NOT considered as colliding
        $chkEdge = \&boundaryDoesntCollideChk;
    }

    # for edge E of triangle 1
    foreach my $i (0, 1, 2) {
        my $j = ($i + 1) % 3;

        # check all points of triangle 2 lay on the external side of edge E
        # if they do, the triangles do not collide
        if ($chkEdge->($t1->[$i], $t1->[$j], $t2->[0], $eps)
        and $chkEdge->($t1->[$i], $t1->[$j], $t2->[1], $eps)
        and $chkEdge->($t1->[$i], $t1->[$j], $t2->[2], $eps)) {
            return 0; # false
        }
    }

    # for edge E of triangle 2
    foreach my $i (0, 1, 2) {
        my $j = ($i + 1) % 3;

        # check all points of triangle 1 lay on the external side of edge E
        # if they do, the triangles do not collide
        if ($chkEdge->($t2->[$i], $t2->[$j], $t1->[0], $eps)
        and $chkEdge->($t2->[$i], $t2->[$j], $t1->[1], $eps)
        and $chkEdge->($t2->[$i], $t2->[$j], $t1->[2], $eps)) {
            return 0; # false
        }
    }

    return 1; # true
}

sub formatTri {
    my $t = shift or die "Missing triangle to format\n";
    my $p1 = $t->[0];
    my $p2 = $t->[1];
    my $p3 = $t->[2];
    return "Triangle: ($p1->{x}, $p1->{y}), ($p2->{x}, $p2->{y}), ($p3->{x}, $p3->{y})";
}

sub overlap {
    my $t1 = shift or die "Missing first triangle to calculate with\n";
    my $t2 = shift or die "Missing second triangle to calculate with\n";
    my $eps = shift;
    my $allowReversed = shift or 0; # false
    my $onBoundary = shift or 1; # true

    unless ($eps) {
        $eps = 0.0;
    }

    if (triTri2D($t1, $t2, $eps, $allowReversed, $onBoundary)) {
        return "overlap\n";
    } else {
        return "do not overlap\n";
    }
}

###################################################
# Main
###################################################

my @t1 = ({x=>0, y=>0}, {x=>5, y=>0}, {x=>0, y=>5});
my @t2 = ({x=>0, y=>0}, {x=>5, y=>0}, {x=>0, y=>6});
print formatTri(\@t1), " and\n", formatTri(\@t2), "\n", overlap(\@t1, \@t2), "\n";

@t1 = ({x=>0, y=>0}, {x=>0, y=>5}, {x=>5, y=>0});
@t2 = ({x=>0, y=>0}, {x=>0, y=>5}, {x=>5, y=>0});
print formatTri(\@t1), " and\n", formatTri(\@t2), "\n", overlap(\@t1, \@t2, 0.0, 1), "\n";

@t1 = ({x=>0, y=>0}, {x=>5, y=>0}, {x=>0, y=>5});
@t2 = ({x=>-10, y=>0}, {x=>-5, y=>0}, {x=>-1, y=>6});
print formatTri(\@t1), " and\n", formatTri(\@t2), "\n", overlap(\@t1, \@t2), "\n";

@t1 = ({x=>0, y=>0}, {x=>5, y=>0}, {x=>2.5, y=>5});
@t2 = ({x=>0, y=>4}, {x=>2.5, y=>-1}, {x=>5, y=>4});
print formatTri(\@t1), " and\n", formatTri(\@t2), "\n", overlap(\@t1, \@t2), "\n";

@t1 = ({x=>0, y=>0}, {x=>1, y=>1}, {x=>0, y=>2});
@t2 = ({x=>2, y=>1}, {x=>3, y=>0}, {x=>3, y=>2});
print formatTri(\@t1), " and\n", formatTri(\@t2), "\n", overlap(\@t1, \@t2), "\n";

@t1 = ({x=>0, y=>0}, {x=>1, y=>1}, {x=>0, y=>2});
@t2 = ({x=>2, y=>1}, {x=>3, y=>-2}, {x=>3, y=>4});
print formatTri(\@t1), " and\n", formatTri(\@t2), "\n", overlap(\@t1, \@t2), "\n";

# Barely touching
@t1 = ({x=>0, y=>0}, {x=>1, y=>0}, {x=>0, y=>1});
@t2 = ({x=>1, y=>0}, {x=>2, y=>0}, {x=>1, y=>1});
print formatTri(\@t1), " and\n", formatTri(\@t2), "\n", overlap(\@t1, \@t2, 0.0, 0, 1), "\n";

# Barely touching
@t1 = ({x=>0, y=>0}, {x=>1, y=>0}, {x=>0, y=>1});
@t2 = ({x=>1, y=>0}, {x=>2, y=>0}, {x=>1, y=>1});
print formatTri(\@t1), " and\n", formatTri(\@t2), "\n", overlap(\@t1, \@t2, 0.0, 0, 0), "\n";
