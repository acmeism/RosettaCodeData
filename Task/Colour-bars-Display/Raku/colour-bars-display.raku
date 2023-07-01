my ($x,$y) = 1280, 720;

my @colors = map -> $r, $g, $b { Buf.new: |(($r, $g, $b) xx $x div 8) },
      0,   0,   0,
    255,   0,   0,
      0, 255,   0,
      0,   0, 255,
    255,   0, 255,
      0, 255, 255,
    255, 255,   0,
    255, 255, 255;

my $img = open "colorbars.ppm", :w orelse die "Can't create colorbars.ppm: $_";

$img.print: qq:to/EOH/;
    P6
    # colorbars.ppm
    $x $y
    255
    EOH

for ^$y {
    for ^@colors -> $h {
        $img.write: @colors[$h];
    }
}

$img.close;
