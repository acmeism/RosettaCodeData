void main() {
    import std.stdio, std.algorithm;

    [1, 3, 2, 9, 1, 2, 3, 8, 8, 1, 0, 2]
    .sort()
    .uniq
    .writeln;
}
