module EC {
  our ($A, $B) = (0, 7);

  our class Point {
    has ($.x, $.y);
    multi method new(
        $x, $y where $y**2 == $x**3 + $A*$x + $B
        ) { samewith :$x, :$y }
    multi method gist { "EC Point at x=$.x, y=$.y" }
    multi method gist(::?CLASS:U:) { 'Point at horizon' }
  }

  multi prefix:<->(Point $p) is export { Point.new: x => $p.x, y => -$p.y }
  multi prefix:<->(Point:U) is export { Point }
  multi infix:<->(Point $a, Point $b) is export { $a + -$b }

  multi infix:<+>(Point:U $, Point $p) is export { $p }
  multi infix:<+>(Point $p, Point:U) is export { $p }

  multi infix:<*>(Point $u, Int $n) is export { $n * $u }
  multi infix:<*>(Int $n, Point:U) is export { Point }
  multi infix:<*>(0, Point) is export { Point }
  multi infix:<*>(1, Point $p) is export { $p }
  multi infix:<*>(2, Point $p) is export {
    my $l = (3*$p.x**2 + $A) / (2 *$p.y);
    my $y = $l*($p.x - my $x = $l**2 - 2*$p.x) - $p.y;
    $p.new(:$x, :$y);
  }
  multi infix:<*>(Int $n where $n > 2, Point $p) is export {
    2 * ($n div 2 * $p) + $n % 2 * $p;
  }

  multi infix:<+>(Point $p, Point $q) is export {
    if $p.x ~~ $q.x {
      return $p.y ~~ $q.y ?? 2 * $p !! Point;
    }
    else {
      my $slope = ($q.y - $p.y) / ($q.x - $p.x);
      my $y = $slope*($p.x - my $x = $slope**2 - $p.x - $q.x) - $p.y;
      return $p.new(:$x, :$y);
    }
  }

}

import EC;

say my $p = EC::Point.new: x => $_, y => sqrt(abs($_**3 + $EC::A*$_ + $EC::B)) given 1;
say my $q = EC::Point.new: x => $_, y => sqrt(abs($_**3 + $EC::A*$_ + $EC::B)) given 2;
say my $s = $p + $q;

use Test;
is abs(($p.x - $q.x)*(-$s.y - $q.y) - ($p.y - $q.y)*($s.x - $q.x)), 0, "S, P and Q are aligned";
