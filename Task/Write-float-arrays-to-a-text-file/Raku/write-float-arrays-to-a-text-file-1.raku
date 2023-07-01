sub writefloat ( $filename, @x, @y, $x_precision = 3, $y_precision = 5 ) {
    my $fh = open $filename, :w;
    for flat @x Z @y -> $x, $y {
        $fh.printf: "%.*g\t%.*g\n", $x_precision, $x, $y_precision, $y;
    }
    $fh.close;
}

my @x = 1, 2, 3, 1e11;
my @y = @x.map({.sqrt});

writefloat( 'sqrt.dat', @x, @y );
