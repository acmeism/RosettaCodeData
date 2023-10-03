# 20230928 Raku programming solution

sub aitken($f, $p0) {
   my $p2   = $f( my $p1 = $f($p0) );
   my $p1m0 = $p1 - $p0;
   return $p0 - $p1m0*$p1m0/($p2-2.0*$p1+$p0);
}

sub steffensenAitken($f, $pinit, $tol, $maxiter) {
   my ($iter, $p) = 1, aitken($f, my $p0 = $pinit);
   while abs($p-$p0) > $tol and $iter < $maxiter {
      $p = aitken($f, $p0 = $p);
      $iter++
   }
   return abs($p-$p0) > $tol ?? NaN !! $p
}

sub deCasteljau($c0, $c1, $c2, $t) {
   my $s = 1.0 - $t;
   return $s*($s*$c0 + $t*$c1) + $t*($s*$c1 + $t*$c2)
}

sub xConvexLeftParabola($t) { return deCasteljau(2.0, -8.0, 2.0, $t) }

sub yConvexRightParabola($t) { return deCasteljau(1.0, 2.0, 3.0, $t) }

sub implicitEquation($x, $y) { return 5.0*$x*$x + $y - 5.0 }

sub f($t) {
   implicitEquation(xConvexLeftParabola($t), yConvexRightParabola($t)) + $t
}

my $t0 = 0.0;
for ^11 {
   print "t0 = {$t0.fmt: '%0.1f'} : ";
   my $t = steffensenAitken(&f, $t0, 0.00000001, 1000);
   if $t.isNaN {
      say "no answer";
   } else {
      my ($x, $y) = xConvexLeftParabola($t), yConvexRightParabola($t);
      if abs(implicitEquation($x, $y)) <= 0.000001 {
         printf "intersection at (%f, %f)\n", $x, $y;
      } else {
         say "spurious solution";
      }
   }
   $t0 += 0.1;
}
