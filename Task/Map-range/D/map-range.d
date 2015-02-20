double mapRange(in double[] a, in double[] b, in double s)
pure nothrow @nogc {
    return b[0] + ((s - a[0]) * (b[1] - b[0]) / (a[1] - a[0]));
}

void main() {
    import std.stdio;

    immutable r1 = [0.0, 10.0];
    immutable r2 = [-1.0, 0.0];
    foreach (immutable s; 0 .. 11)
        writefln("%2d maps to %5.2f", s, mapRange(r1, r2, s));
}
