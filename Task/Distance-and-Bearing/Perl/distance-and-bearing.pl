use v5.36;
use utf8;
binmode STDOUT, ':utf8';
use Text::CSV 'csv';
use Math::Trig;

use constant EARTH_RADIUS_IN_NAUTICAL_MILES => 6372.8 / 1.852;
use constant TAU                            => 2 * 2 * atan2(1, 0);

sub degrees   ( $rad ) { $rad / TAU * 360 }
sub radians   ( $deg ) { $deg * TAU / 360 }
sub haversine ( $x   ) { sin($x / 2)**2   }
sub arc_haver ( $x   ) { asin(sqrt($x)) * 2 }

sub great_circle_distance ( $p1, $l1, $p2, $l2 ) {
    arc_haver(
        haversine($p2 - $p1)
      + haversine($l2 - $l1) * cos($p1) * cos($p2)
    );
}

sub great_circle_bearing ( $p1, $l1, $p2, $l2 ) {
    atan2(                             cos($p2) * sin($l2 - $l1),
        cos($p1)*sin($p2) - sin($p1) * cos($p2) * cos($l2 - $l1),
    );
}

sub distance_and_bearing ( $lat1, $lon1, $lat2, $lon2 ) {
    my @ll = map { radians $_ } $lat1, $lon1, $lat2, $lon2;
    my $dist  = great_circle_distance(@ll);
    my $theta = great_circle_bearing( @ll);
    $dist * EARTH_RADIUS_IN_NAUTICAL_MILES, degrees( $theta < 0 ?  $theta + TAU : $theta);
}

sub find_nearest_airports ( $latitude, $longitude, $csv_path ) {
    my $airports = csv(
        in => $csv_path,
        headers => [<ID Name City Country IATA ICAO Latitude Longitude>],
    );

    for my $row (@$airports) {
        ($$row{'Distance'},$$row{'Bearing'}) = distance_and_bearing( $latitude, $longitude, $$row{'Latitude'}, $$row{'Longitude'} );
    }

    sort { $a->{'Distance'} <=> $b->{'Distance'} } @$airports;
}

my($lat, $lon, $wanted, $csv) = (51.514669, 2.198581, 20, 'ref/airports.dat');
printf "%7s\t%7s\t%-7s\t%-15s\t%s\n", <Dist Bear ICAO Country Name>;
for my $airport (find_nearest_airports($lat, $lon, $csv)) {
    printf "%7.1f\t    %03d\t%-7s\t%-15s\t%s\n", map { $airport->{$_} } <Distance Bearing ICAO Country Name>;
    last unless --$wanted
}
