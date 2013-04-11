import std.stdio, std.random, std.algorithm, std.range;

bool biased(in int n) /*nothrow*/ {
    return uniform(0.0, 1.0) < (1.0 / n);
}

int unbiased(in int bias) /*nothrow*/ {
    int a;
    while ((a = biased(bias)) == biased(bias)) {}
    return a;
}

void main() {
    alias reduce!q{a + b} sum; /**/
    enum int M = 500_000;
    foreach (n; 3 .. 7) {
        immutable a1 = sum(0, iota(M).map!(_=> biased(n))()),
                  a2 = sum(0, iota(M).map!(_=> unbiased(n))());
        writefln("%d: %2.3f%%  %2.3f%%", n,
                 100.0 * a1 / M, 100.0 * a2 / M);
    }
}
