import std.stdio, std.range, std.math, std.conv, std.bigint,
       std.algorithm, std.array;

auto benford(R)(R seq) if (isForwardRange!R && !isInfinite!R) {
    return seq.filter!q{a != 0}.map!q{a.text[0]-'1'}.array.sort().group;
}

void main() {
    auto fibs = recurrence!q{a[n - 1] + a[n - 2]}(1.BigInt, 1.BigInt);
    auto expected = iota(1, 10).map!(d => log10(1.0 + 1.0 / d));

    enum N = 1_000;
    writefln("%9s %9s %9s", "Actual", "Expected", "Deviation");
    foreach (immutable i, immutable f; fibs.take(N).benford)
        writefln("%d: %5.2f%% | %5.2f%% | %5.4f%%", i + 1,
                 f * 100.0 / N, expected[i] * 100,
                 abs((f / double(N)) - expected[i]) * 100);
}
