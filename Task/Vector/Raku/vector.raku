class Vector {
    has Real $.x;
    has Real $.y;

    multi submethod BUILD (:$!x!, :$!y!) {
        *
    }
    multi submethod BUILD (:$length!, :$angle!) {
        $!x = $length * cos $angle;
        $!y = $length * sin $angle;
    }
    multi submethod BUILD (:from([$x1, $y1])!, :to([$x2, $y2])!) {
        $!x = $x2 - $x1;
        $!y = $y2 - $y1;
    }

    method length { sqrt $.x ** 2 + $.y ** 2 }
    method angle  { atan2 $.y, $.x }

    method add      ($v) { Vector.new(x => $.x + $v.x,  y => $.y + $v.y) }
    method subtract ($v) { Vector.new(x => $.x - $v.x,  y => $.y - $v.y) }
    method multiply ($n) { Vector.new(x => $.x * $n,    y => $.y * $n  ) }
    method divide   ($n) { Vector.new(x => $.x / $n,    y => $.y / $n  ) }

    method gist { "vec[$.x, $.y]" }
}

multi infix:<+>  (Vector $v, Vector $w) is export { $v.add: $w }
multi infix:<->  (Vector $v, Vector $w) is export { $v.subtract: $w }
multi prefix:<-> (Vector $v)            is export { $v.multiply: -1 }
multi infix:<*>  (Vector $v, $n)        is export { $v.multiply: $n }
multi infix:</>  (Vector $v, $n)        is export { $v.divide: $n }


#####[ Usage example: ]#####

say my $u = Vector.new(x => 3, y => 4);                #: vec[3, 4]
say my $v = Vector.new(from => [1, 0], to => [2, 3]);  #: vec[1, 3]
say my $w = Vector.new(length => 1, angle => pi/4);    #: vec[0.707106781186548, 0.707106781186547]

say $u.length;                                         #: 5
say $u.angle * 180/pi;                                 #: 53.130102354156

say $u + $v;                                           #: vec[4, 7]
say $u - $v;                                           #: vec[2, 1]
say -$u;                                               #: vec[-3, -4]
say $u * 10;                                           #: vec[30, 40]
say $u / 2;                                            #: vec[1.5, 2]
