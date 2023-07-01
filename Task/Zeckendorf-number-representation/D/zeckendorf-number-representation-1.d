import std.stdio, std.range, std.algorithm, std.functional;

void main() {
    size_t
    .max
    .iota
    .filter!q{ !(a & (a >> 1)) }
    .take(21)
    .binaryReverseArgs!writefln("%(%b\n%)");
}
