class Point {
    has Real $.x is rw = 0;
    has Real $.y is rw = 0;
    method Str { $ }
}

class Circle {
    has Point $.p is rw = Point.new;
    has Real $.r is rw = 0;
    method Str { $ }
}

my $c = Circle.new(p => Point.new(x => 1, y => 2), r => 3);
say $c;
$c.p.x = (-10..10).pick;
$c.p.y = (-10..10).pick;
$c.r   = (0..10).pick;
say $c;
