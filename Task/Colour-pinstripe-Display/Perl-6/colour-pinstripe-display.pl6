my $HOR = 1280;
my $VERT = 720;

my @colors = map -> $r, $g, $b { [$r, $g, $b] },
                     0,  0,  0,
                   255,  0,  0,
                     0,255,  0,
                     0,  0,255,
                   255,  0,255,
                     0,255,255,
                   255,255,  0,
                   255,255,255;

my $PPM = open "pinstripes.ppm", :w, :bin or die "Can't create pinstripes.ppm: $!";

$PPM.print: qq:to/EOH/;
    P3
    # pinstripes.ppm
    $HOR $VERT
    255
    EOH

my $vzones = $VERT div 4;
for 1..4 -> $w {
    my $hzones = ceiling $HOR / $w / +@colors;
    my $line = [((@colors Xxx $w) xx $hzones).flatmap: *.values].splice(0,$HOR);
    $PPM.put: $line for ^$vzones;
}

$PPM.close;
