void main() {
    import std.stdio, std.bigint, std.range, std.algorithm;

    auto squares = 0.sequence!"n".map!(i => i.BigInt ^^ 2);
    auto cubes = 0.sequence!"n".map!(i => i.BigInt ^^ 3);

    squares.setDifference(cubes).drop(20).take(10).writeln;
}
