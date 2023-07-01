my $width = my $height = 255; # must be odd

my @light = normalize([ 3, 2, -5 ]);

my $depth = 255;

sub MAIN ($outfile = 'sphere-perl6.pgm') {
    spurt $outfile, "P5\n$width $height\n$depth\n"; # .pgm header
    my $out = open( $outfile, :a, :bin ) orelse .die;
    $out.write( Blob.new(draw_sphere( ($width-1)/2, .9, .2) ) );
    $out.close;
}

sub normalize (@vec) { @vec »/» ([+] @vec »*« @vec).sqrt }

sub dot (@x, @y) { -([+] @x »*« @y) max 0 }

sub draw_sphere ( $rad, $k, $ambient ) {
    my @pixels[$height];
    my $r2 = $rad * $rad;
    my @range = -$rad .. $rad;
    @range.hyper.map: -> $x {
        my @row[$width];
        @range.map: -> $y {
            if (my $x2 = $x * $x) + (my $y2 = $y * $y) < $r2 {
                my @vector = normalize([$x, $y, ($r2 - $x2 - $y2).sqrt]);
                my $intensity = dot(@light, @vector) ** $k + $ambient;
                my $pixel = (0 max ($intensity * $depth).Int) min $depth;
                @row[$y+$rad] = $pixel;
            }
            else {
                @row[$y+$rad] = 0;
            }
        }
        @pixels[$x+$rad] = @row;
    }
    flat |@pixels.map: *.list;
}
