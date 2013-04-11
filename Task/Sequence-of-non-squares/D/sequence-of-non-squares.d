import std.stdio, std.math, std.algorithm, std.range;

int nonSquare(in int n) pure nothrow {
    return n + cast(int)(0.5 + sqrt(cast(real)n));
}

void main() {
    iota(1, 23).map!nonSquare().writeln();

    foreach (i; 1 .. 1_000_000) {
        int ns = nonSquare(i);
        assert(ns != (cast(int)sqrt(cast(real)ns)) ^^ 2);
    }
}
