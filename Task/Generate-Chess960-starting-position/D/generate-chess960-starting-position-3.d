void main() {
    import std.stdio, std.random, std.array, std.range;

    // Subsequent order unchanged by insertions.
    auto start = "RKR".dup;
    foreach (immutable piece; "QNN")
        start.insertInPlace(uniform(0, start.length), piece);

    immutable bishpos = uniform(0, start.length);
    start.insertInPlace(bishpos, 'B');
    start.insertInPlace(iota(bishpos % 2, start.length, 2)[uniform(0,$)], 'B');
    start.writeln;
}
