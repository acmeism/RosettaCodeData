import std.stdio, std.algorithm, std.range, std.functional;

auto equilibrium(Range)(Range r) /*pure nothrow*/ {
    alias S = curry!(reduce!q{a + b}, 0); // sum
    return r.length.iota().filter!(i => S(r[0..i]) == S(r[i+1..$]))();
}

void main() {
    writeln(equilibrium([-7, 1, 5, 2, -4, 3, 0]));
}
