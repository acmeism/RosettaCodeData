sub Pi () { 3.1415926535897932384626433832795028842 }

sub meanangle {
  my($x, $y) = (0,0);
  ($x,$y) = ($x + sin($_), $y + cos($_)) for @_;
  my $atan = atan2($x,$y);
  $atan += 2*Pi while $atan < 0;    # Ghetto fmod
  $atan -= 2*Pi while $atan > 2*Pi;
  $atan;
}

sub meandegrees {
  meanangle( map { $_ * Pi/180 } @_ ) * 180/Pi;
}

print "The mean angle of [@$_] is: ", meandegrees(@$_), " degrees\n"
  for ([350,10], [90,180,270,360], [10,20,30]);
