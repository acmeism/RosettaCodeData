class EarthPoint {
        has $.lat; # latitude
        has $.lon; # longitude

        has $earth_radius = 6371; # mean earth radius
        has $radian_ratio = pi / 180;

        # accessors for radians
        method latR { $.lat * $radian_ratio }
        method lonR { $.lon * $radian_ratio }

        method haversine-dist(EarthPoint $p) {

                my EarthPoint $arc .= new(
                        lat => $!lat - $p.lat,
                        lon => $!lon - $p.lon );

                my $a = sin($arc.latR/2) ** 2 + sin($arc.lonR/2) ** 2
                        * cos($.latR) * cos($p.latR);
                my $c = 2 * asin( sqrt($a) );

                return $earth_radius * $c;
        }
}

my EarthPoint $BNA .= new(lat => 36.12, lon => -86.67);
my EarthPoint $LAX .= new(lat => 33.94, lon => -118.4);

say $BNA.haversine-dist($LAX); # 2886.44444099822
