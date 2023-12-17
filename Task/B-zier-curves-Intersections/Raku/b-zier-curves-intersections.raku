# 20231025 Raku programming solution

class Point { has ($.x, $.y) is rw is default(0) }

class QuadSpline { has ($.c0, $.c1, $.c2) is rw is default(0) }

class QuadCurve { has QuadSpline ($.x, $.y) is rw }

class Workset { has QuadCurve ($.p, $.q) }

sub subdivideQuadSpline($q, $t) {
   my $s = 1.0 - $t;
   my ($c0,$c1,$c2) = do given $q { .c0, .c1, .c2 };
   my $u_c1 = $s*$c0 + $t*$c1;
   my $v_c1 = $s*$c1 + $t*$c2;
   my $u_c2 = $s*$u_c1 + $t*$v_c1;
   return ($c0, $u_c1, $u_c2), ($u_c2, $v_c1, $c2)
}

sub subdivideQuadCurve($q, $t, $u is rw, $v is rw) {
   with (subdivideQuadSpline($q.x,$t),subdivideQuadSpline($q.y,$t))».List.flat {
      $u=QuadCurve.new(x => QuadSpline.new(c0 => .[0],c1 => .[1],c2 => .[2]),
                       y => QuadSpline.new(c0 => .[6],c1 => .[7],c2 => .[8]));
      $v=QuadCurve.new(x => QuadSpline.new(c0 => .[3],c1 => .[4],c2 => .[5]),
                       y => QuadSpline.new(c0 => .[9],c1 => .[10],c2 => .[11]))
   }
}

sub seemsToBeDuplicate(@intersects, $xy, $spacing) {
   my $seemsToBeDup = False;
   for @intersects {
      $seemsToBeDup = abs(.x - $xy.x) < $spacing && abs(.y - $xy.y) < $spacing;
      last if $seemsToBeDup;
   }
   return $seemsToBeDup;
}

sub rectsOverlap($xa0, $ya0, $xa1, $ya1, $xb0, $yb0, $xb1, $yb1) {
   return $xb0 <= $xa1 && $xa0 <= $xb1 && $yb0 <= $ya1 && $ya0 <= $yb1
}

sub testIntersect($p,$q,$tol,$exclude is rw,$accept is rw,$intersect is rw) {
   my $pxmin = min($p.x.c0, $p.x.c1, $p.x.c2);
   my $pymin = min($p.y.c0, $p.y.c1, $p.y.c2);
   my $pxmax = max($p.x.c0, $p.x.c1, $p.x.c2);
   my $pymax = max($p.y.c0, $p.y.c1, $p.y.c2);
   my $qxmin = min($q.x.c0, $q.x.c1, $q.x.c2);
   my $qymin = min($q.y.c0, $q.y.c1, $q.y.c2);
   my $qxmax = max($q.x.c0, $q.x.c1, $q.x.c2);
   my $qymax = max($q.y.c0, $q.y.c1, $q.y.c2);
   ($exclude, $accept) = True, False;

   if rectsOverlap($pxmin,$pymin,$pxmax,$pymax,$qxmin,$qymin,$qxmax,$qymax) {
      $exclude = False;
      my ($xmin,$xmax) = max($pxmin, $qxmin), min($pxmax, $pxmax);
      if ($xmax < $xmin) { die "Assertion failure: $xmax < $xmin\n" }
      my ($ymin,$ymax) = max($pymin, $qymin), min($pymax, $qymax);
      if ($ymax < $ymin) { die "Assertion failure: $ymax < $ymin\n" }
      if $xmax - $xmin <= $tol and $ymax - $ymin <= $tol {
         $accept = True;
         given $intersect { (.x, .y) = 0.5 X* $xmin+$xmax, $ymin+$ymax }
      }
   }
}

sub find-intersects($p, $q, $tol, $spacing) {
   my Point @intersects;
   my @workload = Workset.new(p => $p, q => $q);

   while my $work = @workload.pop {
      my ($intersect,$exclude,$accept) = Point.new, False, False;
      testIntersect($work.p, $work.q, $tol, $exclude, $accept, $intersect);
      if $accept {
         unless seemsToBeDuplicate(@intersects, $intersect, $spacing) {
            @intersects.push: $intersect;
         }
      } elsif not $exclude {
         my QuadCurve ($p0, $p1, $q0, $q1);
         subdivideQuadCurve($work.p, 0.5, $p0, $p1);
         subdivideQuadCurve($work.q, 0.5, $q0, $q1);
         for $p0, $p1 X $q0, $q1 {
            @workload.push: Workset.new(p => .[0], q => .[1])
         }
      }
   }
   return @intersects;
}

my $p = QuadCurve.new( x => QuadSpline.new(c0 => -1.0,c1 =>  0.0,c2 => 1.0),
                       y => QuadSpline.new(c0 =>  0.0,c1 => 10.0,c2 => 0.0));
my $q = QuadCurve.new( x => QuadSpline.new(c0 =>  2.0,c1 => -8.0,c2 => 2.0),
                       y => QuadSpline.new(c0 =>  1.0,c1 =>  2.0,c2 => 3.0));
my $spacing = ( my $tol = 0.0000001 ) * 10;
.say for find-intersects($p, $q, $tol, $spacing);
