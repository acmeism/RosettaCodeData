# 20240922 Perl programming solution

use strict;
use warnings;
sub aitken {
   my ($f, $p0) = @_;
   my $p2 = $f->( my $p1 = $f->($p0) );
   return $p0 - ($p1 - $p0)**2 / ($p2 - 2 * $p1 + $p0);
}

sub steffensenAitken {
   my ($f, $pinit, $tol, $maxiter) = @_;
   my ($iter,$p) = (1, aitken($f, my $p0 = $pinit) );

   while (abs($p - $p0) > $tol && $iter < $maxiter) {
      $p = aitken($f, $p0 = $p);
      $iter++
   }
   return abs($p - $p0) > $tol ? 'NaN' : $p;
}

sub deCasteljau {
   my ($c0, $c1, $c2, $t) = @_;
   my $s = 1.0 - $t;
   return $s * ($s * $c0 + $t * $c1) + $t * ($s * $c1 + $t * $c2);
}

sub xConvexLeftParabola {
   my ($t) = @_;
   return deCasteljau(2.0, -8.0, 2.0, $t);
}

sub yConvexRightParabola {
   my ($t) = @_;
   return deCasteljau(1.0, 2.0, 3.0, $t);
}

sub implicitEquation {
   my ($x, $y) = @_;
   return 5.0 * ($x ** 2) + $y - 5.0;
}

sub f {
   my ($t) = @_;
   return implicitEquation(xConvexLeftParabola($t), yConvexRightParabola($t)) + $t;
}

for (my $t0 = 0.0, my $i = 0; $i < 11; ++$i) {
   printf("t0 = %.1f : ", $t0);
   my $t = steffensenAitken(\&f, $t0, 1e-8, 1000);

   if ($t eq 'NaN') {
      print "no answer\n";
   } else {
      my ($x, $y) = (xConvexLeftParabola($t), yConvexRightParabola($t));
      if (abs(implicitEquation($x, $y)) <= 1e-6) {
         printf("intersection at (%f, %f)\n", $x, $y);
      } else {
         print "spurious solution\n";
      }
   }
   $t0 += 0.1;
}
