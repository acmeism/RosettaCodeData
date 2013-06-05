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
    P6
    # pinstripes.ppm
    $HOR $VERT
    255
    EOH

my $vzones = $VERT div 4;
for 1..4 -> $w {
    my $hzones = ceiling $HOR / $w / +@colors;
    my $line = Buf.new: ((@colors Xxx $w) xx $hzones).splice(0,$HOR).map: *.values;
    $PPM.write: $line for ^$vzones;
}

$PPM.close;
