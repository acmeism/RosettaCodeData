import std.stdio, std.algorithm, std.range, std.functional;

auto nextCarpet(in string[] c) pure nothrow {
    /*immutable*/ const b = c.map!q{a ~ a ~ a}.array;
    return b ~ c.map!q{a ~ a.replace("#", ' ') ~ a}.array ~ b;
}

void main() {
    ["#"]
    .recurrence!((a, n) => a[n - 1].nextCarpet)
    .dropExactly(3)
    .front
    .binaryReverseArgs!writefln("%-(%s\n%)");
}
