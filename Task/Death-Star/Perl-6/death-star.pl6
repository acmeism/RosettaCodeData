class sphere {
   has $.cx; # center x coordinate
   has $.cy; # center y coordinate
   has $.cz; # center z coordinate
   has $.r;  # radius
}

my $depth = 255;     # image color depth

my $width = my $height = 255; # dimensions of generated .pgm; must be odd

my $s = ($width - 1)/2;  # scaled dimension to build geometry

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
    spurt $outfile, ("P5\n$width $height\n$depth\n"); # .pgm header
    my $out = open( $outfile, :a, :bin ) orelse .die;
    say 'Working...';
    $out.write( Blob.new( |draw_ds(3, .15) ) );
    say 'File written.';
    $out.close;
}

sub draw_ds ( $k, $ambient ) {
    my @pixels[$height];

    (($pos.cy - $pos.r) .. ($pos.cy + $pos.r)).race.map: -> $y {
        my @row[$width];
        (($pos.cx - $pos.r) .. ($pos.cx + $pos.r)).map: -> $x {
            # black if we don't hit positive sphere, ignore negative sphere
            if not hit($pos, $x, $y, my $posz) {
                @row[$x + $s] = 0;
                next;
            }
            my @vec;
            # is front of positive sphere inside negative sphere?
            if hit($neg, $x, $y, my $negz) and $negz.min < $posz.min < $negz.max {
                # make black if whole positive sphere eaten here
                if $negz.min < $posz.max < $negz.max { @row[$x + $s] = 0; next; }
                # render inside of negative sphere
                @vec = normalize([$neg.cx - $x, $neg.cy - $y, -$negz.max - $neg.cz]);
            }
            else {
                # render outside of positive sphere
                @vec = normalize([$x - $pos.cx, $y - $pos.cy,  $posz.max - $pos.cz]);
            }
            my $intensity = dot(@light, @vec) ** $k + $ambient;
            @row[$x + $s] = ($intensity * $depth).Int min $depth;
        }
         @pixels[$y + $s] = @row;
    }
    flat |@pixels.map: *.list;
}

# normalize a vector
sub normalize (@vec) { @vec »/» ([+] @vec »*« @vec).sqrt }

# dot product of two vectors
sub dot (@x, @y) { -([+] @x »*« @y) max 0 }

# are the coordinates within the radius of the sphere?
sub hit ($sphere, $x is copy, $y is copy, $z is rw) {
    $x -= $sphere.cx;
    $y -= $sphere.cy;
    my $z2 = $sphere.r * $sphere.r - $x * $x - $y * $y;
    return 0 if $z2 < 0;
    $z2 = $z2.sqrt;
    $z = $sphere.cz - $z2 .. $sphere.cz + $z2;
    1;
}
