import std.stdio, std.algorithm, std.range;

auto horner(U, V)(U[] p, V x) {
    return reduce!((a, b) => a * x + b)(cast(V)0, retro(p));
}

void main() {
    writeln([-19, 7, -4, 6].horner(3.0));
}
