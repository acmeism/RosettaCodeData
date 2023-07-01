use Imager;

$image = Imager->new(xsize => 200, ysize => 200);
$image->box(filled => 1, color => red);
$image->box(filled => 1, color => black,
            xmin =>  50, ymin =>  50,
            xmax => 150, ymax => 150);
$image->write(file => 'bitmap.ppm') or die $image->errstr;
