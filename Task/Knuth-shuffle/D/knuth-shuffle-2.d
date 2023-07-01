import std.stdio, std.algorithm, std.random, std.range;

void knuthShuffle(Range)(Range r)
if (isRandomAccessRange!Range && hasLength!Range &&
    hasSwappableElements!Range) {
    foreach_reverse (immutable i, ref ri; r[1 .. $ - 1])
        ri.swap(r[uniform(0, i + 1)]);
}

void main() {
    auto a = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    a.knuthShuffle;
    a.writeln;
}
