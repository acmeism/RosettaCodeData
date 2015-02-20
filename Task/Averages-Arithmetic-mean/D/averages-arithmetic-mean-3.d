import std.stdio, std.conv, std.algorithm, std.math, std.traits;

CommonType!(T, real) mean(T)(T[] n ...) if (isNumeric!T) {
    alias E = CommonType!(T, real);
    auto num = n.dup;
    num.schwartzSort!(abs, "a > b");
    return num.map!(to!E).sum(0.0L) / max(1, num.length);
}

void main() {
    writefln("%8.5f", mean((int[]).init));
    writefln("%8.5f", mean(     0, 3, 1, 4, 1, 5, 9, 0));
    writefln("%8.5f", mean([-1e20, 3, 1, 4, 1, 5, 9, 1e20]));
}
