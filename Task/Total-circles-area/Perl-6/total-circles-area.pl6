class Point {
    has Real $.x;
    has Real $.y;
    has Int $!cbits;	# bitmap of circle membership

    method cbits { $!cbits //= set_cbits(self) }
    method gist { $!x ~ "\t" ~ $!y }
}

multi infix:<to>(Point $p1, Point $p2) {
    sqrt ($p1.x - $p2.x) ** 2 + ($p1.y - $p2.y) ** 2;
}

multi infix:<mid>(Point $p1, Point $p2) {
    Point.new(x => ($p1.x + $p2.x) / 2, y => ($p1.y + $p2.y) / 2);
}

class Circle {
    has Point $.center;
    has Real $.radius;

    has Point $.north = Point.new(x => $!center.x, y => $!center.y + $!radius);
    has Point $.west  = Point.new(x => $!center.x - $!radius, y => $!center.y);
    has Point $.south = Point.new(x => $!center.x, y => $!center.y - $!radius);
    has Point $.east  = Point.new(x => $!center.x + $!radius, y => $!center.y);

    multi method contains(Circle $c) { $!center to $c.center <= $!radius - $c.radius }
    multi method contains(Point $p) { $!center to $p <= $!radius }
    method gist { $!center.gist ~ "\t" ~ $.radius }
}

class Rect {
    has Point $.nw;
    has Point $.ne;
    has Point $.sw;
    has Point $.se;

    method diag { $!ne to $!se }
    method area { ($!ne.x - $!nw.x) * ($!nw.y - $!sw.y) }
    method contains(Point $p) {
	$!nw.x < $p.x < $!ne.x and
	$!sw.y < $p.y < $!nw.y;
    }
}

my @rawcircles = sort -*.radius,
    map -> $x, $y, $radius { Circle.new(:center(Point.new(:$x, :$y)), :$radius) },
    <
	 1.6417233788  1.6121789534 0.0848270516
	-1.4944608174  1.2077959613 1.1039549836
	 0.6110294452 -0.6907087527 0.9089162485
	 0.3844862411  0.2923344616 0.2375743054
	-0.2495892950 -0.3832854473 1.0845181219
	 1.7813504266  1.6178237031 0.8162655711
	-0.1985249206 -0.8343333301 0.0538864941
	-1.7011985145 -0.1263820964 0.4776976918
	-0.4319462812  1.4104420482 0.7886291537
	 0.2178372997 -0.9499557344 0.0357871187
	-0.6294854565 -1.3078893852 0.7653357688
	 1.7952608455  0.6281269104 0.2727652452
	 1.4168575317  1.0683357171 1.1016025378
	 1.4637371396  0.9463877418 1.1846214562
	-0.5263668798  1.7315156631 1.4428514068
	-1.2197352481  0.9144146579 1.0727263474
	-0.1389358881  0.1092805780 0.7350208828
	 1.5293954595  0.0030278255 1.2472867347
	-0.5258728625  1.3782633069 1.3495508831
	-0.1403562064  0.2437382535 1.3804956588
	 0.8055826339 -0.0482092025 0.3327165165
	-0.6311979224  0.7184578971 0.2491045282
	 1.4685857879 -0.8347049536 1.3670667538
	-0.6855727502  1.6465021616 1.0593087096
	 0.0152957411  0.0638919221 0.9771215985
    >».Num;

# remove redundant circles
my @circles;
while @rawcircles {
    my $c = @rawcircles.shift;
    next if @circles.any.contains($c);
    push @circles, $c;
}

sub set_cbits(Point $p) {
    my $cbits = 0;
    for @circles Z (1,2,4...*) -> ($c, $b) {
	$cbits += $b if $c.contains($p);
    }
    $cbits;
}

my $xmin = min @circles.map: { .center.x - .radius }
my $xmax = max @circles.map: { .center.x + .radius }
my $ymin = min @circles.map: { .center.y - .radius }
my $ymax = max @circles.map: { .center.y + .radius }

my $min-radius = @circles[*-1].radius;

my $outer-rect = Rect.new:
    nw => Point.new(x => $xmin, y => $ymax),
    ne => Point.new(x => $xmax, y => $ymax),
    sw => Point.new(x => $xmin, y => $ymin),
    se => Point.new(x => $xmax, y => $ymin);

my $outer-area = $outer-rect.area;

my @unknowns = $outer-rect;
my $known-dry = 0e0;
my $known-wet = 0e0;
my $div = 1;

# divide current rects each into four rects, analyze each
sub divide(@old) {

    $div *= 2;

    # rects too small to hold circle?
    my $smallish = @old[0].diag < $min-radius;

    my @unk;
    for @old {
	my $center = .nw mid .se;
	my $north = .nw mid .ne;
	my $south = .sw mid .se;
	my $west = .nw mid .sw;
	my $east = .ne mid .se;

	for Rect.new(nw => .nw, ne => $north, sw => $west, se => $center),
	    Rect.new(nw => $north, ne => .ne, sw => $center, se => $east),
	    Rect.new(nw => $west, ne => $center, sw => .sw, se => $south),
	    Rect.new(nw => $center, ne => $east, sw => $south, se => .se)
	{
	    my @bits = .nw.cbits, .ne.cbits, .sw.cbits, .se.cbits;

	    # if all 4 points wet by same circle, guaranteed wet
	    if [+&] @bits {
		$known-wet += .area;
		next;
	    }

	    # if all 4 corners are dry, must check further
	    if not [+|] @bits and $smallish {

		# check that no circle bulges into this rect
		my $ok = True;
		for @circles -> $c {
		    if .contains($c.east) or .contains($c.west) or
			.contains($c.north) or .contains($c.south)
		    {
			$ok = False;
			last;
		    }
		}
		if $ok {
		    $known-dry += .area;
		    next;
		}
	    }
	    push @unk, $_;	# dunno yet
	}
    }
    @unk;
}

my $delta = 0.001;
repeat until my $diff < $delta {
    @unknowns = divide(@unknowns);

    $diff = $outer-area - $known-dry - $known-wet;
    say 'div: ', $div.fmt('%-5d'),
	' unk: ', (+@unknowns).fmt('%-6d'),
	' est: ', ($known-wet + $diff/2).fmt('%9.6f'),
	' wet: ', $known-wet.fmt('%9.6f'),
	' dry: ', ($outer-area - $known-dry).fmt('%9.6f'),
	' diff: ', $diff.fmt('%9.6f'),
	' error: ', ($diff - @unknowns * @unknowns[0].area).fmt('%e');
}
