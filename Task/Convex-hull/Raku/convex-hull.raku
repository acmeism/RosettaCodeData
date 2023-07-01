class Point {
    has Real $.x is rw;
    has Real $.y is rw;
    method gist { [~] '(', self.x,', ', self.y, ')' };
}

sub ccw (Point $a, Point $b, Point $c) {
    ($b.x - $a.x)*($c.y - $a.y) - ($b.y - $a.y)*($c.x - $a.x);
}

sub tangent (Point $a, Point $b) {
    my $opp = $b.x - $a.x;
    my $adj = $b.y - $a.y;
    $adj != 0 ?? $opp / $adj !! Inf
}

sub graham-scan (**@coords) {
    # sort points by y, secondary sort on x
    my @sp = @coords.map( { Point.new( :x($_[0]), :y($_[1]) ) } )
                    .sort: {.y, .x};

    # need at least 3 points to make a hull
    return @sp if +@sp < 3;

    # first point on hull is minimum y point
    my @h  = @sp.shift;

    # re-sort the points by angle, secondary on x
    @sp    = @sp.map( { $++ => [tangent(@h[0], $_), $_.x] } )
                .sort( {-$_.value[0], $_.value[1] } )
                .map: { @sp[$_.key] };

    # first point of re-sorted list is guaranteed to be on hull
    @h.push:  @sp.shift;

    # check through the remaining list making sure that
    # there is always a positive angle
    for @sp -> $point {
        if ccw( |@h.tail(2), $point ) > 0 {
            @h.push: $point;
        } else {
            @h.pop;
            @h.push: $point and next if +@h < 2;
            redo;
        }
    }
    @h
}

my @hull = graham-scan(
    (16, 3), (12,17), ( 0, 6), (-4,-6), (16, 6), (16,-7), (16,-3),
    (17,-4), ( 5,19), (19,-8), ( 3,16), (12,13), ( 3,-4), (17, 5),
    (-3,15), (-3,-9), ( 0,11), (-9,-3), (-4,-2), (12,10)
  );

say "Convex Hull ({+@hull} points): ", @hull;

@hull = graham-scan(
    (16, 3), (12,17), ( 0, 6), (-4,-6), (16, 6), (16,-7), (16,-3),
    (17,-4), ( 5,19), (19,-8), ( 3,16), (12,13), ( 3,-4), (17, 5),
    (-3,15), (-3,-9), ( 0,11), (-9,-3), (-4,-2), (12,10), (20,-9), (1,-9)
  );

say "Convex Hull ({+@hull} points): ", @hull;
