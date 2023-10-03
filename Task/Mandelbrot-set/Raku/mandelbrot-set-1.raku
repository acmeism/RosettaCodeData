constant MAX-ITERATIONS = 64;
my $width = +(@*ARGS[0] // 800);
my $height = $width + $width %% 2;
say "P2";
say "$width $height";
say MAX-ITERATIONS;

sub cut(Range $r, UInt $n where $n > 1 --> Seq) {
    $r.min, * + ($r.max - $r.min) / ($n - 1) ... $r.max
}

my @re = cut(-2 .. 1/2, $width);
my @im = cut( 0 .. 5/4, 1 + ($height div 2)) X* 1i;

sub mandelbrot(Complex $z is copy, Complex $c --> Int) {
    for 1 .. MAX-ITERATIONS {
        $z = $z*$z + $c;
        return $_ if $z.abs > 2;
    }
    return 0;
}

my @lines = hyper for @im X+ @re {
  mandelbrot(0i, $_);
}.rotor($width);

.put for @lines[1..*].reverse;
.put for @lines;
