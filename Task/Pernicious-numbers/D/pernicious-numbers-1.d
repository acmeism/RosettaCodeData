void main() {
    import std.stdio, std.algorithm, std.range, core.bitop;

    immutable pernicious = (in uint n) => (2 ^^ n.popcnt) & 0xA08A28AC;
    uint.max.iota.filter!pernicious.take(25).writeln;
    iota(888_888_877, 888_888_889).filter!pernicious.writeln;
}
