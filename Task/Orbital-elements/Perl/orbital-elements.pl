use strict;
use warnings;
use Math::Vector::Real;

sub orbital_state_vectors {
    my (
        $semimajor_axis,
        $eccentricity,
        $inclination,
        $longitude_of_ascending_node,
        $argument_of_periapsis,
        $true_anomaly
    ) = @_[0..5];

    my ($i, $j, $k) = (V(1,0,0), V(0,1,0), V(0,0,1));

    sub rotate {
        my $alpha = shift;
        @_[0,1] = (
            +cos($alpha)*$_[0] + sin($alpha)*$_[1],
            -sin($alpha)*$_[0] + cos($alpha)*$_[1]
        );
    }

    rotate $longitude_of_ascending_node, $i, $j;
    rotate $inclination,                 $j, $k;
    rotate $argument_of_periapsis,       $i, $j;

    my $l = $eccentricity == 1 ? # PARABOLIC CASE
        2*$semimajor_axis :
        $semimajor_axis*(1 - $eccentricity**2);

    my ($c, $s) = (cos($true_anomaly), sin($true_anomaly));

    my $r = $l/(1 + $eccentricity*$c);
    my $rprime = $s*$r**2/$l;

    my $position = $r*($c*$i + $s*$j);

    my $speed =
    ($rprime*$c - $r*$s)*$i + ($rprime*$s + $r*$c)*$j;
    $speed /= abs($speed);
    $speed *= sqrt(2/$r - 1/$semimajor_axis);

    {
        position => $position,
        speed    => $speed
    }
}

use Data::Dumper;

print Dumper orbital_state_vectors
    1,                             # semimajor axis
    0.1,                           # eccentricity
    0,                             # inclination
    355/113/6,                     # longitude of ascending node
    0,                             # argument of periapsis
    0                              # true-anomaly
    ;
