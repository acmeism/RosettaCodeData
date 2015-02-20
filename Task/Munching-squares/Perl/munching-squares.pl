use GD;

my $img = new GD::Image(256, 256, 1);

for my $y(0..255) {
        for my $x(0..255) {
                my $color = $img->colorAllocate( abs(255 - $x - $y),  (255-$x) ^ $y , $x ^ (255-$y));
                $img->setPixel($x, $y, $color);
        }
}

print $img->png
