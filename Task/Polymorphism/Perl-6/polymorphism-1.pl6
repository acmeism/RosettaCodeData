class Point {
    has Num $.x is rw = 0;
    has Num $.y is rw = 0;
    method Str { $.perl }
}

class Circle {
    has Point $.p is rw = Point.new;
    has Num $.r is rw = 0;
    method Str { $.perl }
}

my $c = Circle.new(Point.new(x => 1, y => 2), r => 3);
say $c;
$c.p.x = (-10..10).pick;
$c.p.y = (-10..10).pick;
$c.r   = (0..10).pick;
say $c;
