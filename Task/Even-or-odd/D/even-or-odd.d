void main() {
    import std.stdio, std.bigint;

    foreach (immutable i; -5 .. 6)
        writeln(i, " ", i & 1, " ", i % 2, " ", i.BigInt % 2);
}
