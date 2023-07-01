use Image::PNG::Portable;

my ($w, $h) = 400, 400;
my $out = Image::PNG::Portable.new: :width($w), :height($h);

plasma($out);

$out.write: 'Plasma-perl6.png';

sub plasma ($png) {
    (^$w).race.map: -> $x {
        for ^$h -> $y {
            my $hue = 4 + sin($x / 19) + sin($y / 9) + sin(($x + $y) / 25) + sin(sqrt($x² + $y²) / 8);
            $png.set: $x, $y, |hsv2rgb($hue/8, 1, 1);
        }
    }
}

sub hsv2rgb ( $h, $s, $v ){
    my $c = $v * $s;
    my $x = $c * (1 - abs( (($h*6) % 2) - 1 ) );
    my $m = $v - $c;
    (do given $h {
        when   0..^1/6 { $c, $x, 0 }
        when 1/6..^1/3 { $x, $c, 0 }
        when 1/3..^1/2 { 0, $c, $x }
        when 1/2..^2/3 { 0, $x, $c }
        when 2/3..^5/6 { $x, 0, $c }
        when 5/6..1    { $c, 0, $x }
    } ).map: ((*+$m) * 255).Int
}
