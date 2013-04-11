sub plot(\x, \y, \c) { say "plot {x} {y} {c}" }

sub fpart(\x) { x - floor(x) }

sub draw-line(@a is copy, @b is copy) {
    my Bool \steep = abs(@b[1] - @a[1]) > abs(@b[0] - @a[0]);
    my $plot = &OUTER::plot;

    if steep {
	$plot = -> $y, $x, $c { plot($x, $y, $c) }
	@a.=reverse;
	@b.=reverse;
    }
    if @a[0] > @b[0] { my @t = @a; @a = @b; @b = @t }

    my (\x0,\y0) = @a;
    my (\x1,\y1) = @b;

    my \dx = x1 - x0;
    my \dy = y1 - y0;
    my \gradient = dy / dx;

    # handle first endpoint
    my \x-end1 = round(x0);
    my \y-end1 = y0 + gradient * (x-end1 - x0);
    my \x-gap1 = 1 - round(x0 + 0.5);

    my \x-pxl1 = x-end1;   # this will be used in the main loop
    my \y-pxl1 = floor(y-end1);
    my \c1 = fpart(y-end1) * x-gap1;

    $plot(x-pxl1, y-pxl1    , 1 - c1) unless c1 == 1;
    $plot(x-pxl1, y-pxl1 + 1, c1    ) unless c1 == 0;

    # handle second endpoint
    my \x-end2 = round(x1);
    my \y-end2 = y1 + gradient * (x-end2 - x1);
    my \x-gap2 = fpart(x1 + 0.5);

    my \x-pxl2 = x-end2; # this will be used in the main loop
    my \y-pxl2 = floor(y-end2);
    my \c2 = fpart(y-end2) * x-gap2;

    my \intery = y-end1 + gradient;

    # main loop
    for (x-pxl1 + 1 .. x-pxl2 - 1)
	Z
	(intery, intery + gradient ... *)
    -> \x,\y {
	my \c = fpart(y);
	$plot(x, floor(y)    , 1 - c) unless c == 1;
	$plot(x, floor(y) + 1, c    ) unless c == 0;
    }

    $plot(x-pxl2, y-pxl2    , 1 - c2) unless c2 == 1;
    $plot(x-pxl2, y-pxl2 + 1, c2    ) unless c2 == 0;
}

draw-line [0,1], [10,2];
