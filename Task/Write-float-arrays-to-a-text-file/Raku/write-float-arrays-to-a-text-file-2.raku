sub writefloat($filename, @x, @y, :$x-precision = 3, :$y-precision = 3) {
    open($filename, :w).print:
        join '', flat (@x».fmt("%.{$x-precision}g") X "\t") Z (@y».fmt("%.{$y-precision}g") X "\n");
}
my @x = 1, 2, 3, 1e11;
writefloat('sqrt.dat', @x, @x».sqrt, :y-precision(5));
