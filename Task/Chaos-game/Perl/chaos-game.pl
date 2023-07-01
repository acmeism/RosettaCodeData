use Imager;

my $width  = 1000;
my $height = 1000;

my @points = (
    [ $width/2,         0],
    [        0, $height-1],
    [$height-1, $height-1],
);

my $img = Imager->new(
                      xsize    => $width,
                      ysize    => $height,
                      channels => 3,
                     );

my $color = Imager::Color->new('#ff0000');
my $r = [int(rand($width)), int(rand($height))];

foreach my $i (1 .. 100000) {
    my $p = $points[rand @points];

    my $h = [
        int(($p->[0] + $r->[0]) / 2),
        int(($p->[1] + $r->[1]) / 2),
    ];

    $img->setpixel(
        x     => $h->[0],
        y     => $h->[1],
        color => $color,
    );

    $r = $h;
}

$img->write(file => 'chaos_game_triangle.png');
