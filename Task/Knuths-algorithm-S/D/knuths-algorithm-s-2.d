import std.stdio, std.random, std.algorithm;

struct SOfN(int n) {
    size_t i;
    int[n] sample = void;
    static rng = Xorshift(0);

    int[] next(in int item) {
        i++;
        if (i <= n)
            sample[i - 1] = item;
        else if (uniform(0.0, 1.0, rng) < (cast(double)n / i))
            sample[uniform(0, n, rng)] = item;
        return sample[0 .. min(i, $)];
    }
}

void main() {
    enum nRuns = 100_000;
    size_t[10] bin;

    foreach (trial; 0 .. nRuns) {
        SOfN!(3) sofn;
        foreach (item; 0 .. bin.length - 1)
            sofn.next(item);
        foreach (s; sofn.next(bin.length - 1))
            bin[s]++;
    }
    writefln("Item counts for %d runs:\n%s", nRuns, bin);
}
