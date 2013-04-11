my $x = my $y = 255;
$x +|= 1; # must be odd

my @light = normalize([ 3, 2, -5 ]);

my $depth = 255;

sub MAIN ($outfile = 'sphere-perl6.pgm') {
    my $out = open( $outfile, :w, :bin ) or die "$!\n";
    $out.say("P5\n$x $y\n$depth"); # .pgm header
    $out.print( draw_sphere( ($x-1)/2, .9, .2)».chrs );
    $out.close;
}

sub normalize (@vec) { return @vec »/» ([+] @vec Z* @vec).sqrt }

sub dot (@x, @y) { return -([+] @x Z* @y) max 0 }

sub draw_sphere ( $rad, $k, $ambient ) {
    my @pixels;
    my $r2 = $rad * $rad;
    my @range = -$rad .. $rad;
    for @range X @range -> $x, $y {
        if (my $x2 = $x * $x) + (my $y2 = $y * $y) < $r2 {
            my @vector = normalize([$x, $y, ($r2 - $x2 - $y2).sqrt]);
            my $intensity = dot(@light, @vector) ** $k + $ambient;
            my $pixel = (0 max ($intensity * $depth).Int) min $depth;
            @pixels.push($pixel);
        }
        else {
            @pixels.push(0);
        }
    }
    return @pixels;
}
