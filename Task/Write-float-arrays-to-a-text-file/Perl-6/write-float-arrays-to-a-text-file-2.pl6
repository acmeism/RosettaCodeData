sub writefloat($filename, @x, @y, :$x-precision = 3, :$y-precision = 5) {
    constant TAB = "\t" xx *;
    constant NL = "\n" xx *;

    open($filename, :w).print(
        flat @x>>.base(10, $x-precision) Z TAB Z @y>>.base(10, $y-precision) Z NL);
}
my @x = 1, 2, 3, 1e11;
writefloat('sqrt.dat', @x, @x>>.sqrt, :y-precision(20));
