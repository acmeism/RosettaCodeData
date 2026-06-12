my @Geo32 = <0 1 2 3 4 5 6 7 8 9 b c d e f g h j k m n p q r s t u v w x y z>;

sub geo-encode ( Rat(Real) $latitude, Rat(Real) $longitude, Int $precision = 9 ) {
    my @coord = $latitude, $longitude;
    my @range = [-90, 90], [-180, 180];
    my $which = 1;
    my $value = '';
    while $value.chars < $precision * 5 {
        my $mid = @range[$which].sum / 2;
        $value ~= my $upper = +(@coord[$which] > $mid);
        @range[$which][not $upper] = $mid;
        $which = not $which;
    }
    @Geo32[$value.comb(5)».parse-base(2)].join;
}

sub geo-decode ( Str $geo ) {
     my @range = [-90, 90], [-180, 180];
     my $which = 1;
     my %Geo32 = @Geo32.antipairs;
     for %Geo32{$geo.comb}».fmt('%05b').join.comb {
         @range[$which][$_] = @range[$which].sum / 2;
         $which = not $which;
     }
     @range
}

# TESTING

for 51.433718,   -0.214126,  2, # Ireland, most of England and Wales, small part of Scotland
    51.433718,   -0.214126,  9, # the umpire's chair on Center Court at Wimbledon
    51.433718,   -0.214126, 17, # likely an individual molecule of the chair
    57.649110,   10.407440, 11, # Wikipedia test value - Råbjerg Mile in Denmark
    59.358639,   24.744778,  7, # Lake Raku in Estonia
    29.2021188, 81.5324561,  7  # Village Raku in Nepal
  -> $lat, $long, $precision {
     say "$lat, $long, $precision:\ngeo-encoded: ",
     my $enc = geo-encode $lat, $long, $precision;
     say 'geo-decoded: ', geo-decode($enc).map( {-.sum/2 ~ ' ± ' ~
          (abs(.[0]-.[1])/2).Num.fmt('%.3e')} ).join(',  ') ~ "\n";
}
