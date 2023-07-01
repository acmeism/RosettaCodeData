void main() {
    import std.stdio, std.algorithm, std.mathspecial;

    foreach (immutable n; 1 .. 18) {
        immutable x = gamma(n + 1) / (2 * LN2 ^^ (n + 1)),
                  tenths = cast(int)floor((x - x.floor) * 10);
        writefln("H(%2d)=%22.2f is %snearly integer.", n, x,
                  tenths.among!(0, 9) ? "" : "NOT ");
    }
}
