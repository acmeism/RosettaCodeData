use utf8;
binmode STDOUT, ":utf8";

use constant π => 3.14159265;

sub d2r { $_[0] * π / 180 } # degrees to radians
sub r2d { $_[0] * 180 / π } # radians to degrees

print 'Enter latitude       => '; $latitude  = <>;
print 'Enter longitude      => '; $longitude = <>;
print 'Enter legal meridian => '; $meridian  = <>;

$lat_sin = sin( d2r($latitude) );
$offset = $meridian - $longitude;
print 'Sine of latitude: ' . sprintf "%.4f\n", $lat_sin;
print 'Longitude offset: ' . $offset . "\n";
print '=' x 48 . "\n";
print " Hour : Sun hour angle°: Dial hour line angle°\n";

for $hour (-6 .. 6) {
    my $sun_deg  = $hour * 15 + $offset;
    my $line_deg = r2d atan2( ( sin(d2r($sun_deg)) * $lat_sin ), cos(d2r($sun_deg)) );
    printf "%2d %s     %8.3f            %8.3f\n",
    ($hour + 12) % 12 || 12, ($hour < 0 ? 'AM' : 'PM'), $sun_deg, $line_deg;
}
