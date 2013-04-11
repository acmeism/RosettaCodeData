import std.stdio, std.range, std.algorithm, std.conv, std.string;

void main() {
    iota(1, 11).map!text().join(", ").writeln();
}
