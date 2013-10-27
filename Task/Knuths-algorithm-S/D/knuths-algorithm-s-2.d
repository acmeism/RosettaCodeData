import std.stdio, std.random, std.algorithm;

double random01(ref Xorshift rng) {
    immutable r = rng.front / cast(double)rng.max;
    rng.popFront;
    return r;
}

struct SOfN(size_t n) {
    size_t i;
    int[n] sample = void;

    int[] next(in size_t item, ref Xorshift rng) {
        i++;
        if (i <= n)
            sample[i - 1] = item;
        else if (rng.random01 < (cast(double)n / i))
            sample[uniform(0, n, rng)] = item;
        return sample[0 .. min(i, $)];
    }
}

void main() {
    enum nRuns = 100_000;
    size_t[10] bin;
    auto rng = Xorshift(0);

    foreach (immutable trial; 0 .. nRuns) {
        SOfN!3 sofn;
        foreach (immutable item; 0 .. bin.length - 1)
            sofn.next(item, rng);
        foreach (immutable s; sofn.next(bin.length - 1, rng))
            bin[s]++;
    }
    writefln("Item counts for %d runs:\n%s", nRuns, bin);
}
