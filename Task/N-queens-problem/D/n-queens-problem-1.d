void main() {
    import std.stdio, std.algorithm, std.range, permutations2;

    enum n = 8;
    n.iota.array.permutations.filter!(p =>
        n.iota.map!(i => p[i] + i).array.sort().uniq.count == n &&
        n.iota.map!(i => p[i] - i).array.sort().uniq.count == n)
    .count.writeln;
}
