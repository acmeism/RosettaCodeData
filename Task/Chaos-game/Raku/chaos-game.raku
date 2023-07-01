use Image::PNG::Portable;

my ($w, $h) = (640, 640);

my $png = Image::PNG::Portable.new: :width($w), :height($h);

my @vertex = [0, 0], [$w, 0], [$w/2, $h];

my @xy = [0,0], [0,0], [0,0], [0,0];

# :degree must be equal to or less than @xy elements.
(^1e5).race(:4degree).map: {
    my $p = ++$ % +@xy;
    @xy[$p] = do given @vertex.pick -> @v { ((@xy[$p] »+« @v) »/» 2)».Int };
    $png.set: |@xy[$p], 0, 255, 0;
}

$png.write: 'Chaos-game-perl6.png';
