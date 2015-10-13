class sphere {
   has $.cx; # center x coordinate
   has $.cy; # center y coordinate
   has $.cz; # center z coordinate
   has $.r;  # radius
}

my $depth = 255;     # image color depth

my $x = my $y = 255; # dimensions of generated .pgm; must be odd

my $s = ($x - 1)/2;  # scaled dimension to build geometry

my @light = normalize([ 4, -1, -3 ]);

# positive sphere at origin
my $pos = sphere.new(
    cx => 0,
    cy => 0,
    cz => 0,
    r  => $s.Int
);

# negative sphere offset to upper left
my $neg = sphere.new(
    cx => (-$s*.90).Int,
    cy => (-$s*.90).Int,
    cz => (-$s*.3).Int,
    r  => ($s*.7).Int
);

sub MAIN ($outfile = 'deathstar-perl6.pgm') {
    my $out = open( $outfile, :w, :bin ) or die "$!\n";
    $out.say("P5\n$x $y\n$depth"); # .pgm header
    say 'Calculating row:';
    $out.write( Blob.new( draw_ds(3, .15) ) );
    $out.close;
}

sub draw_ds ( $k, $ambient ) {
    my @pixels;
    my $bs = "\b" x 8;
    for ($pos.cy - $pos.r) .. ($pos.cy + $pos.r) -> $y {
        print $bs, $y, ' '; # monitor progress
        for ($pos.cx - $pos.r) .. ($pos.cx + $pos.r) -> $x {
            # black if we don't hit positive sphere, ignore negative sphere
            if not hit($pos, $x, $y, my $posz) {
                @pixels.push(0);
                next;
            }
            my @vec;
            # is front of positive sphere inside negative sphere?
            if hit($neg, $x, $y, my $negz) and $negz.min < $posz.min < $negz.max {
                # make black if whole positive sphere eaten here
                if $negz.min < $posz.max < $negz.max { @pixels.push(0); next; }
                # render inside of negative sphere
                @vec = normalize([$neg.cx - $x, $neg.cy - $y, -$negz.max - $neg.cz]);
            }
            else {
                # render outside of positive sphere
                @vec = normalize([$x - $pos.cx, $y - $pos.cy,  $posz.max - $pos.cz]);
            }
            my $intensity = dot(@light, @vec) ** $k + $ambient;
            @pixels.push( ($intensity * $depth).Int min $depth );
        }
    }
    say $bs, 'Writing file.';
    return @pixels;
}

# normalize a vector
sub normalize (@vec) { return @vec »/» ([+] @vec »*« @vec).sqrt }

# dot product of two vectors
sub dot (@x, @y) { return -([+] @x »*« @y) max 0 }

# are the coordinates within the radius of the sphere?
sub hit ($sphere, $x is copy, $y is copy, $z is rw) {
    $x -= $sphere.cx;
    $y -= $sphere.cy;
    my $z2 = $sphere.r * $sphere.r - $x * $x - $y * $y;
    return 0 if $z2 < 0;
    $z2 = $z2.sqrt;
    $z = $sphere.cz - $z2 .. $sphere.cz + $z2;
    return 1;
}
