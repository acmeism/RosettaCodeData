my $HOR = 1280;
my $VERT = 720;

my @colors = 0, 1;

my $PPM = open "pinstripes.pgm", :w, :bin or die "Can't create pinstripes.ppm: $!";

$PPM.print: qq:to/EOH/;
    P5
    # pinstripes.pgm
    $HOR $VERT
    1
    EOH

my $vzones = $VERT div 4;
for 1..4 -> $w {
    my $hzones = ceiling $HOR / $w / +@colors;
    my $line = Buf.new: ((@colors Xxx $w) xx $hzones).splice(0,$HOR);
    $PPM.write: $line for ^$vzones;
}

$PPM.close;
