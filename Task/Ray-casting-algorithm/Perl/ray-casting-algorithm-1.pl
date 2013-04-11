use strict;
use List::Util qw(max min);

sub point_in_polygon
{
    my ( $point, $polygon ) = @_;

    my $count = 0;
    foreach my $side ( @$polygon ) {
	$count++ if ray_intersect_segment($point, $side);
    }
    return ($count % 2 == 0) ? 0 : 1;
}


my $eps = 0.0001;
my $inf = 1e600;

sub ray_intersect_segment
{
    my ($point, $segment) = @_;

    my ($A, $B) = @$segment;

    my @P = @$point; # copy it

    ($A, $B) = ($B, $A) if $A->[1] > $B->[1];

    $P[1] += $eps if ($P[1] == $A->[1]) || ($P[1] == $B->[1]);

    return 0 if ($P[1] < $A->[1]) || ( $P[1] > $B->[1]) || ($P[0] > max($A->[0],$B->[1]) );
    return 1 if $P[0] < min($A->[0], $B->[0]);

    my $m_red = ($A->[0] != $B->[0]) ? ( $B->[1] - $A->[1] )/($B->[0] - $A->[0]) : $inf;
    my $m_blue = ($A->[0] != $P[0]) ? ( $P[1] - $A->[1] )/($P[0] - $A->[0]) : $inf;

    return ($m_blue >= $m_red) ? 1 : 0;
}
