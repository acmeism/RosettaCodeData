import std.stdio, std.bigint, std.algorithm, std.range;

auto cumu(in uint n) {
    __gshared cache = [[1.BigInt]];
    foreach (l; cache.length .. n + 1) {
        auto r = [0.BigInt];
        foreach (x; 1 .. l + 1)
            r ~= r.back + cache[l - x][min(x, l - x)];
        cache ~= r;
    }
    return cache[n];
}

auto row(in uint n) {
    auto r = n.cumu;
    return n.iota.map!(i => r[i + 1] - r[i]);
}

void main() {
    writeln("Rows:");
    foreach (x; 1 .. 11)
        writefln("%2d: %s", x, x.row);

    writeln("\nSums:");
    foreach (x; [23, 123, 1234])
        writeln(x, " ", x.cumu.back);
}
