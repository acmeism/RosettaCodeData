import std.stdio, std.algorithm, std.math;

double entropy(T)(T[] s)
/*pure nothrow*/ if (__traits(compiles, sort(s))) {
    return s
           .sort()
           .group
           .map!(g => g[1] / cast(double)s.length)
           .map!(p => -p * log2(p))
           .reduce!q{a + b};
}

void main() {
    "1223334444"d.dup.entropy.writeln;
}
