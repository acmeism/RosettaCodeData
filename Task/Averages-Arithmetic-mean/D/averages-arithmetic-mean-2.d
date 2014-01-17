import std.stdio, std.algorithm, std.range;

real mean(Range)(Range r) pure nothrow {
    return reduce!q{a + b}(0.0L, r) / max(1.0L, r.count);
}

void main() {
    writeln("Mean: ", (int[]).init.mean);
    writeln("Mean: ", [3, 1, 4, 1, 5, 9].mean);
}
