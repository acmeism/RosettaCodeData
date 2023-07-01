use strict;
use warnings;
use feature 'say';

sub det2D {
    my($p1,$p2,$p3) = @_;
    return $p1->[0] * ($p2->[1] - $p3->[1])
         + $p2->[0] * ($p3->[1] - $p1->[1])
         + $p3->[0] * ($p1->[1] - $p2->[1]);
}

# triangles must be expressed anti-clockwise
sub checkTriWinding {
    my($p1,$p2,$p3,$allowReversed) = @_;
    my $detTri = det2D($p1, $$p2, $$p3);
    if ($detTri < 0.0) {
        if ($allowReversed) { ($$p3,$$p2) = ($$p2,$$p3) }
        else                { die "triangle has wrong winding direction" }
    }
    return undef;
}

sub check_edge {
    our($t1,$t2,$eps,$onBoundary) = @_;

    # points on the boundary may be considered as colliding, or not
    my $chkEdge = $onBoundary ?  \&boundaryCollideChk : \&boundaryDoesntCollideChk;
    sub boundaryCollideChk       { return det2D($_[0], $_[1], $_[2]) <  $eps }
    sub boundaryDoesntCollideChk { return det2D($_[0], $_[1], $_[2]) <= $eps }

    # for edge E of triangle 1
    foreach my $i (0, 1, 2) {
        my $j = ($i + 1) % 3;

        # check all points of triangle 2 lay on the external side of edge E
        # if they do, the triangles do not collide
        if ($chkEdge->($$t1->[$i], $$t1->[$j], $$t2->[0], $eps)
        and $chkEdge->($$t1->[$i], $$t1->[$j], $$t2->[1], $eps)
        and $chkEdge->($$t1->[$i], $$t1->[$j], $$t2->[2], $eps)) {
            return 0; # false
        }
    }
    return 1;
}

sub triTri2D {
    my($t1,$t2,$eps,$allowReversed,$onBoundary) = @_;
    checkTriWinding($$t1->[0], \$$t1->[1], \$$t1->[2], $allowReversed);
    checkTriWinding($$t2->[0], \$$t2->[1], \$$t2->[2], $allowReversed);
    return check_edge($t1,$t2,$eps,$onBoundary) && check_edge($t2,$t1,$eps,$onBoundary);
}

sub formatTri {
    my $t = shift;
    my @pairs;
    push @pairs, sprintf "%8s", '(' . $$_[0] . ',' . $$_[1] . ')' for @$$t;
    join ', ', @pairs;
}

sub overlap {
    my $t1            = shift or die "Missing first triangle to calculate with\n";
    my $t2            = shift or die "Missing second triangle to calculate with\n";
    my $eps           = shift || 0;
    my $allowReversed = shift || 1;
    my $onBoundary    = shift || 1;

    my $triangles = formatTri($t1) . ' and ' . formatTri($t2);
    if (triTri2D($t1, $t2, $eps, $allowReversed, $onBoundary)) {
        return "       overlap:" . $triangles;
    } else {
        return "do not overlap:" . $triangles;
    }
}

my @tests = (
   [ [[0,0], [5,0],   [0,5]], [   [0,0],    [5,0],  [0,6]] ],
   [ [[0,0], [0,5],   [5,0]], [   [0,0],    [0,5],  [5,0]] ],
   [ [[0,0], [5,0],   [0,5]], [ [-10,0],   [-5,0], [-1,6]] ],
   [ [[0,0], [5,0], [2.5,5]], [   [0,4], [2.5,-1],  [5,4]] ],
   [ [[0,0], [1,1],   [0,2]], [   [2,1],    [3,0],  [3,2]] ],
   [ [[0,0], [1,1],   [0,2]], [   [2,1],   [3,-2],  [3,4]] ],             # barely touching
   [ [[0,0], [1,0],   [0,1]], [   [1,0],    [2,0],  [1,1]], 0.0, 0, 0 ]   # barely touching
);

say overlap(\$_->[0], \$_->[1], $_->[2], $_->[3], $_->[4]) for @tests;
