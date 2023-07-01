import std.stdio, std.algorithm, std.array, std.typecons,
       std.range, std.exception;

auto meanStdDev(R)(R numbers) /*nothrow*/ @safe /*@nogc*/ {
    if (numbers.empty)
        return tuple(0.0L, 0.0L);

    real sx = 0.0, sxx = 0.0;
    ulong n;
    foreach (x; numbers) {
        sx += x;
        sxx += x ^^ 2;
        n++;
    }
    return tuple(sx / n, (n * sxx - sx ^^ 2) ^^ 0.5L / n);
}

void showHistogram01(R)(R numbers) /*@safe*/ {
    enum maxWidth = 50; // N. characters.
    ulong[10] bins;
    foreach (immutable x; numbers) {
        immutable index = cast(size_t)(x * bins.length);
        enforce(index >= 0 && index < bins.length);
        bins[index]++;
    }
    immutable real maxFreq = bins.reduce!max;

    foreach (immutable n, immutable i; bins)
        writefln(" %3.1f: %s", n / real(bins.length),
                 replicate("*", cast(int)(i / maxFreq * maxWidth)));
    writeln;
}

version (statistics_basic_main) {
    void main() @safe {
        import std.random;

        foreach (immutable p; 1 .. 7) {
            auto n = iota(10L ^^ p).map!(_ => uniform(0.0L, 1.0L));
            writeln(10L ^^ p, " numbers:");
            writefln(" Mean: %8.6f, SD: %8.6f", n.meanStdDev.tupleof);
            n.showHistogram01;
        }
    }
}
