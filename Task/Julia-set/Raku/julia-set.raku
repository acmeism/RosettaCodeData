use Image::PNG::Portable;

my ($w, $h) = 800, 600;
my $out = Image::PNG::Portable.new: :width($w), :height($h);

my $maxIter = 255;
my $c = -0.7 + 0.27015i;

julia($out);

$out.write: 'Julia-set-perl6.png';

sub julia ( $png ) {
    ^$w .race.map: -> $x {
        for ^$h -> $y {
            my $z = Complex.new(($x - $w / 2) / $w * 3, ($y - $h / 2) / $h * 2);
            my $i = $maxIter;
            while (abs($z) < 2 and --$i) {
                $z = $z*$z + $c;
            }
            $png.set: $x, $y, |hsv2rgb($i / $maxIter, 1, ?$i).reverse;
        }
    }
}

sub hsv2rgb ( $h, $s, $v ){
    my $c = $v * $s;
    my $x = $c * (1 - abs( (($h*6) % 2) - 1 ) );
    my $m = $v - $c;
    [(do given $h {
        when   0..^1/6 { $c, $x, 0 }
        when 1/6..^1/3 { $x, $c, 0 }
        when 1/3..^1/2 { 0, $c, $x }
        when 1/2..^2/3 { 0, $x, $c }
        when 2/3..^5/6 { $x, 0, $c }
        when 5/6..1    { $c, 0, $x }
    } ).map: ((*+$m) * 255).Int]
}
