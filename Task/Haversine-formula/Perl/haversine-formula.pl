use ntheory qw/Pi/;

sub asin { my $x = shift; atan2($x, sqrt(1-$x*$x)); }

sub surfacedist {
  my($lat1, $lon1, $lat2, $lon2) = @_;
  my $radius = 6372.8;
  my $radians = Pi() / 180;;
  my $dlat = ($lat2 - $lat1) * $radians;
  my $dlon = ($lon2 - $lon1) * $radians;
  $lat1 *= $radians;
  $lat2 *= $radians;
  my $a = sin($dlat/2)**2 + cos($lat1) * cos($lat2) * sin($dlon/2)**2;
  my $c = 2 * asin(sqrt($a));
  return $radius * $c;
}

printf "Distance: %.3f km\n", surfacedist(36.12, -86.67, 33.94, -118.4);
