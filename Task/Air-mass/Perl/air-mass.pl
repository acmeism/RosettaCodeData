use strict;
use warnings;
use feature <say signatures>;
no warnings 'experimental::signatures';
use List::Util 'max';

use constant PI  => 2*atan2(1,0);   # π
use constant DEG => PI/180;         # degrees to radians
use constant RE  => 6371000;        # Earth radius in meters
use constant dd  => 0.001;          # integrate in this fraction of the distance already covered
use constant FIN => 10000000;       # integrate only to a height of 10000km, effectively infinity

# Density of air as a function of height above sea level
sub rho ( $a ) {
    exp( -$a / 8500 );
}

sub height ( $a, $z, $d ) {
    # a = altitude of observer
    # z = zenith angle (in degrees)
    # d = distance along line of sight
    my $AA = RE + $a;
    my $HH = sqrt $AA**2 + $d**2 - 2 * $d * $AA * cos( (180-$z)*DEG );
    $HH - RE;
}

# Integrates density along the line of sight
sub column_density ( $a, $z ) {
    my $sum = 0;
    my $d   = 0;
    while ($d < FIN) {
        my $delta = max(dd, dd * $d);  # Adaptive step size to avoid it taking forever
        $sum += rho(height($a, $z, $d + $delta/2))*$delta;
        $d   += $delta;
    }
    $sum;
}

sub airmass ( $a, $z ) {
    column_density($a, $z) / column_density($a, 0);
}

say 'Angle     0 m              13700 m';
say '------------------------------------';
for my $z (map{ 5*$_ } 0..18) {
    printf "%2d      %11.8f      %11.8f\n", $z, airmass(0, $z), airmass(13700, $z);
}
