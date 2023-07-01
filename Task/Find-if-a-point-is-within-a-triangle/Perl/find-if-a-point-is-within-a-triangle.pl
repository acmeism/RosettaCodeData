# 20201123 added Perl programming solution

use strict;
use warnings;

use List::AllUtils qw(min max natatime);
use constant EPSILON        =>           0.001;
use constant EPSILON_SQUARE => EPSILON*EPSILON;

sub side {
   my ($x1, $y1, $x2, $y2, $x, $y) = @_;
   return ($y2 - $y1)*($x - $x1) + (-$x2 + $x1)*($y - $y1);
}

sub naivePointInTriangle {
   my ($x1, $y1, $x2, $y2, $x3, $y3, $x, $y) = @_;
   my $checkSide1 = side($x1, $y1, $x2, $y2, $x, $y) >= 0 ;
   my $checkSide2 = side($x2, $y2, $x3, $y3, $x, $y) >= 0 ;
   my $checkSide3 = side($x3, $y3, $x1, $y1, $x, $y) >= 0 ;
   return $checkSide1 && $checkSide2 && $checkSide3  || 0 ;
}

sub pointInTriangleBoundingBox {
   my ($x1, $y1, $x2, $y2, $x3, $y3, $x, $y) = @_;
   my $xMin = min($x1, min($x2, $x3)) - EPSILON;
   my $xMax = max($x1, max($x2, $x3)) + EPSILON;
   my $yMin = min($y1, min($y2, $y3)) - EPSILON;
   my $yMax = max($y1, max($y2, $y3)) + EPSILON;
   ( $x < $xMin || $xMax < $x || $y < $yMin || $yMax < $y ) ? 0 : 1
}

sub distanceSquarePointToSegment {
   my ($x1, $y1, $x2, $y2, $x, $y) = @_;
   my $p1_p2_squareLength = ($x2 - $x1)**2 + ($y2 - $y1)**2;
   my $dotProduct = ($x-$x1)*($x2-$x1)+($y-$y1)*($y2-$y1) ;
   if ( $dotProduct < 0 ) {
      return ($x - $x1)**2 + ($y - $y1)**2;
   } elsif ( $dotProduct <= $p1_p2_squareLength ) {
      my $p_p1_squareLength = ($x1 - $x)**2 + ($y1 - $y)**2;
      return $p_p1_squareLength - $dotProduct**2 / $p1_p2_squareLength;
   } else {
      return ($x - $x2)**2 + ($y - $y2)**2;
   }
}

sub accuratePointInTriangle {
   my ($x1, $y1, $x2, $y2, $x3, $y3, $x, $y) = @_;
   return 0 unless pointInTriangleBoundingBox($x1,$y1,$x2,$y2,$x3,$y3,$x,$y);
   return 1 if ( naivePointInTriangle($x1, $y1, $x2, $y2, $x3, $y3, $x, $y)
      or distanceSquarePointToSegment($x1, $y1, $x2, $y2, $x, $y) <= EPSILON_SQUARE
      or distanceSquarePointToSegment($x2, $y2, $x3, $y3, $x, $y) <= EPSILON_SQUARE
      or distanceSquarePointToSegment($x3, $y3, $x1, $y1, $x, $y) <= EPSILON_SQUARE);
   return 0
}

my @DATA = (1.5, 2.4, 5.1, -3.1, -3.8, 0.5);

for my $point ( [0,0] , [0,1] ,[3,1] ) {
   print "Point (", join(',',@$point), ") is within triangle ";
   my $iter = natatime 2, @DATA;
   while ( my @vertex = $iter->()) { print '(',join(',',@vertex),') ' }
   print ': ',naivePointInTriangle (@DATA, @$point) ? 'True' : 'False', "\n" ;
}
