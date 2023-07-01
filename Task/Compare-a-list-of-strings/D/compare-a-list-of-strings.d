void main() {
    import std.stdio, std.algorithm, std.range, std.string;

    foreach (const strings; ["AA AA AA AA", "AA ACB BB CC"].map!split) {
        strings.writeln;
        strings.zip(strings.dropOne).all!(ab => ab[0] == ab[1]).writeln;
        strings.zip(strings.dropOne).all!(ab => ab[0] < ab[1]).writeln;
        writeln;
    }
}
