use Image::PNG::Portable;

my ($w, $h) = (400, 400);

my $png = Image::PNG::Portable.new: :width($w), :height($h);

(0, .025 ... 52*π).race.map: -> \Θ {
    $png.set: |((cis( Θ / π ) * Θ).reals »+« ($w/2, $h/2))».Int, 255, 0, 255;
}

$png.write: 'Archimedean-spiral-perl6.png';
