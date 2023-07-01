use Imager;

sub tree {
    my ($img, $x1, $y1, $x2, $y2, $depth) = @_;

    return () if $depth <= 0;

    my $dx = ($x2 - $x1);
    my $dy = ($y1 - $y2);

    my $x3 = ($x2 - $dy);
    my $y3 = ($y2 - $dx);
    my $x4 = ($x1 - $dy);
    my $y4 = ($y1 - $dx);
    my $x5 = ($x4 + 0.5 * ($dx - $dy));
    my $y5 = ($y4 - 0.5 * ($dx + $dy));

    # Square
    $img->polygon(
        points => [
            [$x1, $y1],
            [$x2, $y2],
            [$x3, $y3],
            [$x4, $y4],
        ],
        color => [0, 255 / $depth, 0],
    );

    # Triangle
    $img->polygon(
        points => [
            [$x3, $y3],
            [$x4, $y4],
            [$x5, $y5],
        ],
        color => [0, 255 / $depth, 0],
    );

    tree($img, $x4, $y4, $x5, $y5, $depth - 1);
    tree($img, $x5, $y5, $x3, $y3, $depth - 1);
}

my ($width, $height) = (1920, 1080);
my $img = Imager->new(xsize => $width, ysize => $height);
$img->box(filled => 1, color => 'white');
tree($img, $width/2.3, $height, $width/1.8, $height, 10);
$img->write(file => 'pythagoras_tree.png');
