import std.stdio, std.algorithm, std.math;

double entropy(T)(T[] s)
pure nothrow if (__traits(compiles, s.sort())) {
    immutable sLen = s.length;
    return s
           .sort()
           .group
           .map!(g => g[1] / double(sLen))
           .map!(p => -p * p.log2)
           .sum;
}

void main() {
    "1223334444"d.dup.entropy.writeln;
}
