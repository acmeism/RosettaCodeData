void main() {
    import std.stdio, std.random;

    auto a = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    a.randomShuffle;
    a.writeln;
}
