unit module EC;
our ($A, $B) = (0, 7);

role Horizon { method gist { 'EC Point at horizon' } }
class Point {
    has ($.x, $.y);
    multi method new(
        $x, $y where $y**2 ~~ $x**3 + $A*$x + $B
    ) { self.bless(:$x, :$y) }
    multi method new(Horizon $) { self.bless but Horizon }
    method gist { "EC Point at x=$.x, y=$.y" }
}

multi prefix:<->(Point $p) { Point.new: x => $p.x, y => -$p.y }
multi prefix:<->(Horizon $) { Horizon }
multi infix:<->(Point $a, Point $b) { $a + -$b }

multi infix:<+>(Horizon $, Point $p) { $p }
multi infix:<+>(Point $p, Horizon) { $p }

multi infix:<*>(Point $u, Int $n) { $n * $u }
multi infix:<*>(Int $n, Horizon) { Horizon }
multi infix:<*>(0, Point) { Horizon }
multi infix:<*>(1, Point $p) { $p }
multi infix:<*>(2, Point $p) {
    my $l = (3*$p.x**2 + $A) / (2 *$p.y);
    my $y = $l*($p.x - my $x = $l**2 - 2*$p.x) - $p.y;
    $p.bless(:$x, :$y);
}
multi infix:<*>(Int $n where $n > 2, Point $p) {
    2 * ($n div 2 * $p) + $n % 2 * $p;
}

multi infix:<+>(Point $p, Point $q) {
    if $p.x ~~ $q.x {
        return $p.y ~~ $q.y ?? 2 * $p !! Horizon;
    }
    else {
        my $slope = ($q.y - $p.y) / ($q.x - $p.x);
        my $y = $slope*($p.x - my $x = $slope**2 - $p.x - $q.x) - $p.y;
        return $p.new(:$x, :$y);
    }
}

say my $p = Point.new: x => $_, y => sqrt(abs($_**3 + $A*$_ + $B)) given 1;
say my $q = Point.new: x => $_, y => sqrt(abs($_**3 + $A*$_ + $B)) given 2;
say my $s = $p + $q;

say "checking alignment:  ", abs ($p.x - $q.x)*(-$s.y - $q.y) - ($p.y - $q.y)*($s.x - $q.x);
