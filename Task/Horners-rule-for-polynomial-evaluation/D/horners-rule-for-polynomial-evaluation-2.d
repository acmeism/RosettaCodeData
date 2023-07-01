import std.stdio, std.traits;

CommonType!(U, V) horner(U, V)(U[] p, V x) pure nothrow @nogc {
    typeof(return) accumulator = 0;
    foreach_reverse (c; p)
        accumulator = accumulator * x + c;
    return accumulator;
}

void main() {
    [-19, 7, -4, 6].horner(3.0).writeln;
}
