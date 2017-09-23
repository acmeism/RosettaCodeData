use feature 'say';
sub circles_from_p1p2r {
    my ($x1, $y1, $x2, $y2, $r) = @_;
    die 'Radius is zero' if $r == 0.0;
    die 'coincident points gives infinite number of Circles' if $x1 == $x2 && $y1 == $y2;
    # delta x, delta y between points
    my ($dx, $dy) = ($x2 - $x1, $y2 - $y1);
    my $q = sqrt($dx**2 + $dy**2);
    die 'separation of points > diameter' if $q > 2.0*$r;
    # halfway point
    my ($x3, $y3) = (($x1 + $x2) / 2, ($y1 + $y2) / 2);
    # distance along the mirror line
    my $d = sqrt($r**2-($q/2)**2);
    # One answer
    my @c1 = ($x3 - $d*$dy/$q, $y3 + $d*$dx/$q, $r);
    # The other answer
    my @c2 = ($x3 + $d*$dy/$q, $y3 - $d*$dx/$q, $r);
    return (@c1, @c2);
  }

my @arr = ([0.1234, 0.9876, 0.8765, 0.2345, 2.0],
	   [0.0000, 2.0000, 0.0000, 0.0000, 1.0],
	   # [0.1234, 0.9876, 0.1234, 0.9876, 2.0],
	   # [0.1234, 0.9876, 0.8765, 0.2345, 0.5],
	   # [0.1234, 0.9876, 0.1234, 0.9876, 0.0]
	  );
for(@arr) {
  my @res = circles_from_p1p2r @{$_};
  say "@res";
}
