sub MAIN ($filename = 'default.ppm') {

    my $in = open($filename, :r, :enc<iso-8859-1>) or die $in;

    my ($type, $dim, $depth) = $in.lines[^3];

    my $outfile = $filename.subst('.ppm', '.pgm');
    my $out = open($outfile, :w, :enc<iso-8859-1>) or die $out;

    $out.say("P5\n$dim\n$depth");

    for $in.lines.ords -> $r, $g, $b {
        my $gs = $r * 0.2126 + $g * 0.7152 + $b * 0.0722;
        $out.print: chr($gs.floor min 255);
    }

    $in.close;
    $out.close;
}
