import std.stdio, std.algorithm, std.range, std.functional;

auto equilibrium(Range)(Range r) pure nothrow @safe /*@nogc*/ {
    return r.length.iota.filter!(i => r[0 .. i].sum == r[i + 1 .. $].sum);
}

void main() {
    [-7, 1, 5, 2, -4, 3, 0].equilibrium.writeln;
}
