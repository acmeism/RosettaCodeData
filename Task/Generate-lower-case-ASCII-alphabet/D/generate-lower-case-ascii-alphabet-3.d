void main() {
    import std.range, std.algorithm, std.array;

    char[26] arr = 26.iota.map!(i => cast(char)('a' + i)).array;
}
