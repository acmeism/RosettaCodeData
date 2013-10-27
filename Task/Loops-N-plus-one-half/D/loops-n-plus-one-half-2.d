void main() {
    import std.stdio, std.range, std.algorithm, std.conv, std.string;
    iota(1, 11).map!text.join(", ").writeln;

    // A simpler solution:
    writefln("%(%d, %)", iota(1, 11));
}
