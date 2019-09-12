my ($x,$y) = 1280, 720;

my @colors = map -> $r, $g, $b { [$r, $g, $b] },
     0,   0,   0,
   255,   0,   0,
     0, 255,   0,
     0,   0, 255,
   255,   0, 255,
     0, 255, 255,
   255, 255,   0,
   255, 255, 255;

my $img = open "pinstripes.ppm", :w orelse die "Can't create pinstripes.ppm: $_";

$img.print: qq:to/EOH/;
    P3
    # pinstripes.ppm
    $x $y
    255
    EOH

my $vzones = $y div 4;
for 1..4 -> $width {
    my $stripes = ceiling $x / $width / +@colors;
    my $row = [((@colors Xxx $width) xx $stripes).flatmap: *.values].splice(0,$x);
    $img.put: $row for ^$vzones;
}

$img.close;
