import std.stdio, std.range, std.algorithm;

void main() {
    writefln("%(%b\n%)", iota(size_t.max)
                         .filter!q{ !(a & (a >> 1)) }
                         .take(21));
}
