double vdc(int n, in double base=2.0) pure nothrow @safe @nogc {
    double vdc = 0.0, denom = 1.0;
    while (n) {
        denom *= base;
        vdc += (n % base) / denom;
        n /= base;
    }
    return vdc;
}

void main() {
    import std.stdio, std.algorithm, std.range;

    foreach (immutable b; 2 .. 6)
        writeln("\nBase ", b, ": ", 10.iota.map!(n => vdc(n, b)));
}
