import std.stdio, std.algorithm, std.range, std.functional;

alias S = curry!(reduce!q{a + b}, 0); // Sum.

auto equilibrium(Range)(Range r) pure nothrow {
    return r.length.iota.filter!(i => r[0 .. i].S == r[i + 1 .. $].S);
}

void main() {
    [-7, 1, 5, 2, -4, 3, 0].equilibrium.writeln;
}
