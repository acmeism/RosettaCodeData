my $HOR = 1280;
my $VERT = 720;

my @colors = 0, 1;

spurt "pinstripes.pgm", qq:to/EOH/;
    P5
    # pinstripes.pgm
    $HOR $VERT
    1
    EOH

my $PGM = open "pinstripes.pgm", :a, :bin or die "Can't append to pinstripes.pgm: $!";

my $vzones = $VERT div 4;
for 1..4 -> $w {
    my $hzones = ceiling $HOR / $w / +@colors;
    my $line = Buf.new: (flat((@colors Xxx $w) xx $hzones).Array).splice(0,$HOR);
    $PGM.write: $line for ^$vzones;
}

$PGM.close;
