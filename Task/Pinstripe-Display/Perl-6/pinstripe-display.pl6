my ($x,$y) = 1280,720;
my @colors = 0, 1;

spurt "pinstripes.pgm", qq:to/EOH/ orelse .die;
    P5
    # pinstripes.pgm
    $x $y
    1
    EOH

my $img = open "pinstripes.pgm", :a, :bin orelse .die;

my $vzones = $y div 4;
for 1..4 -> $w {
    my $stripes = ceiling $x / $w / +@colors;
    my $line = Buf.new: (flat((@colors Xxx $w) xx $stripes).Array).splice(0,$x); # DH change 2015-12-20
    $img.write: $line for ^$vzones;
}

$img.close;
