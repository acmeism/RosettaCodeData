import std.stdio, std.algorithm, std.range;

auto horner(T, U)(in T[] p, in U x) pure nothrow @nogc {
    return reduce!((a, b) => a * x + b)(U(0), p.retro);
}

void main() {
    [-19, 7, -4, 6].horner(3.0).writeln;
}
