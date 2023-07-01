import std.stdio, std.algorithm, std.bigint, std.functional, std.range;

auto product(R)(R r) { return reduce!q{a * b}(1.BigInt, r); }

const cats1 = sequence!((a, n) => iota(n+2, 2*n+1).product / iota(1, n+1).product)(1);

BigInt cats2a(in uint n) {
    alias mcats2a = memoize!cats2a;
    if (n == 0) return 1.BigInt;
    return n.iota.map!(i => mcats2a(i) * mcats2a(n - 1 - i)).sum;
}

const cats2 = sequence!((a, n) => n.cats2a);

const cats3 = recurrence!q{ (4*n - 2) * a[n - 1] / (n + 1) }(1.BigInt);

void main() {
    foreach (cats; TypeTuple!(cats1, cats2, cats3))
        cats.take(15).writeln;
}
