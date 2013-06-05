my $HOR = 1280;
my $VERT = 720;

my @colors = map -> $r, $g, $b { Buf.new: ($r, $g, $b) xx $HOR div 8 },
                  0,  0,  0,
                255,  0,  0,
                  0,255,  0,
                  0,  0,255,
                255,  0,255,
                  0,255,255,
                255,255,  0,
                255,255,255;

my $PPM = open "colorbars.ppm", :w, :bin or die "Can't create colorbars.ppm: $!";

$PPM.print: qq:to/EOH/;
    P6
    # colorbars.ppm
    $HOR $VERT
    255
    EOH

for ^$VERT -> $v {
    for ^@colors -> $h {
        $PPM.write: @colors[$h];
    }
}

$PPM.close;
