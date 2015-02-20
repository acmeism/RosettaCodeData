import std.stdio, std.range, std.math, std.conv, std.bigint;

double[2][9] benford(R)(R seq) if (isForwardRange!R && !isInfinite!R) {
    typeof(return) freqs = 0;
    uint seqLen = 0;
    foreach (d; seq)
        if (d != 0) {
            freqs[d.text[0] - '1'][1]++;
            seqLen++;
        }

    foreach (immutable i, ref p; freqs)
        p = [log10(1.0 + 1.0 / (i + 1)), p[1] / seqLen];
    return freqs;
}

void main() {
    auto fibs = recurrence!q{a[n - 1] + a[n - 2]}(1.BigInt, 1.BigInt);

    writefln("%9s %9s %9s", "Actual", "Expected", "Deviation");
    foreach (immutable i, immutable p; fibs.take(1000).benford)
        writefln("%d: %5.2f%% | %5.2f%% | %5.4f%%",
                 i+1, p[1] * 100, p[0] * 100, abs(p[1] - p[0]) * 100);
}
