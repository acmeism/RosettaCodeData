my $wininfo = qx[xwininfo -root];
my ($width,$height) = ($wininfo ~~ /'Width: ' (\d+) .*? 'Height: ' (\d+)/)[];
($width,$height) = 1280,768 unless $width;

my $PGM = open "greybars.pgm", :w or die "Can't create greybars.pgm: $!";

$PGM.print: qq:to/EOH/;
    P2
    # greybars.pgm
    $width $height
    65535
    EOH

my ($h1,$h2,$h3,$h4) = divvy($height,4);

my @nums = ((0/7,1/7...7/7) X* 65535)».floor;
my $line = ~(@nums Zxx divvy($width,8));
$PGM.say: $line for ^$h1;

@nums = ((15/15,14/15...0/15) X* 65535)».floor;
$line = ~(@nums Zxx divvy($width,16));
$PGM.say: $line for ^$h2;

@nums = ((0/31,1/31...31/31) X* 65535)».floor;
$line = ~(@nums Zxx divvy($width,32));
$PGM.say: $line for ^$h3;

@nums = ((63/63,62/63...0/63) X* 65535)».floor;
$line = ~(@nums Zxx divvy($width,64));
$PGM.say: $line for ^$h4;

$PGM.close;

shell "eog -f greybars.pgm";

sub divvy($all, $div) {
    my @marks = ((1/$div,2/$div ... 1) X* $all)».round;
    @marks Z- 0,@marks;
}
