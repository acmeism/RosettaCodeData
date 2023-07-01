use Image::PNG::Portable;

my ($w, $h) = 800, 800;
my $out = Image::PNG::Portable.new: :width($w), :height($h);

my $maxIter = 150;

my @re = scale(-2.05 .. 1.05, $h);
my @im = scale( -11/8 .. 11/8, $w) X* 1i;

for ^($w div 2) -> $x {
    ^$h .map: -> $y {
        my $i = (mandelbrot( @re[$y] + @im[$x] ) / $maxIter) ** .25;
        my @hsv = hsv2rgb($i, 1, ?$i).rotate;
        $out.set: $x, $y, |@hsv;
        $out.set: $w - 1 - $x, $y, |@hsv;
    }
}

$out.write: 'Mandelbrot-set-perl6.png';

sub scale (Range $r,Int $n) { $r.min, * + ($r.max - $r.min) / ($n - 1) ... $r.max }

sub mandelbrot(Complex $c) {
    my $z = $c;
    for ^$maxIter {
	    $z = $z * $z + $c;
	    .return if $z.abs > 2;
    }
    0
}

sub hsv2rgb ( $h, $s, $v ){
    state %cache;
    %cache{"$h|$s|$v"} //= do {
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
}
