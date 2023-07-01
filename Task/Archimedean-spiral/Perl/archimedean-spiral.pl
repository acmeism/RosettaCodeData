use Imager;
use constant PI => 3.14159265;

my ($w, $h) = (400, 400);
my $img = Imager->new(xsize => $w, ysize => $h);

for ($theta = 0; $theta < 52*PI; $theta += 0.025) {
    $x = $w/2 + $theta * cos($theta/PI);
    $y = $h/2 + $theta * sin($theta/PI);
    $img->setpixel(x => $x, y => $y, color => '#FF00FF');
}

$img->write(file => 'Archimedean-spiral.png');
