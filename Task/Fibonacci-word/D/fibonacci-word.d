import std.stdio, std.algorithm, std.math, std.string, std.range;

real entropy(T)(T[] s) pure nothrow
if (__traits(compiles, s.sort())) {
    immutable sLen = s.length;
    return s
           .sort()
           .group
           .map!(g => g[1] / real(sLen))
           .map!(p => -p * p.log2)
           .sum;
}

void main() {
    enum uint nMax = 37;

    "  N     Length               Entropy Fibword".writeln;
    uint n = 1;
    foreach (s; recurrence!q{a[n - 1] ~ a[n - 2]}("1", "0").take(nMax))
        writefln("%3d %10d %2.19f %s", n++, s.length,
                 s.dup.representation.entropy.abs,
                 s.length < 25 ? s : "<too long>");
}
