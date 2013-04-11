import std.stdio, std.math, std.range, std.algorithm;

auto nthRoots(in int n) /*pure nothrow*/ {
    return iota(n).map!(k => expi(PI * 2 * (k + 1) / n))();
}

void main() {
    foreach (i; 1 .. 6)
        writefln("#%d: [%(%5.2f, %)]", i, nthRoots(i));
}
