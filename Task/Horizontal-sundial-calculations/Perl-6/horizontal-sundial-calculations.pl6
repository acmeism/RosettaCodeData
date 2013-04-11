sub postfix:<°> ($a) { $a * pi / 180 } # degrees to radians
sub postfix:<®> ($a) { $a * 180 / pi } # radians to degrees

my $latitude  = prompt 'Enter latitude       => ';
my $longitude = prompt 'Enter longitude      => ';
my $meridian  = prompt 'Enter legal meridian => ';

my $lat_sin = sin( $latitude° );
say 'Sine of latitude: ', $lat_sin.fmt("%.4f");
say 'Longitude offset: ', my $offset = $meridian - $longitude;
say '=' x 48;
say ' Hour  : Sun hour angle° : Dial hour line angle°';

for -6 .. 6 -> $hour {
    my $sun_deg  = $hour * 15 + $offset;
    my $line_deg = atan2( ( sin($sun_deg°) * $lat_sin ), cos($sun_deg°) )®;
    printf "%2d %s      %7.3f             %7.3f\n",
    ($hour + 12) % 12 || 12, ($hour < 0 ?? 'AM' !! 'PM'), $sun_deg, $line_deg;
}
