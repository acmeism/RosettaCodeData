import std.stdio, std.random;

auto sofN_creator(in int n) {
    size_t i;
    int[] sample;

    return (in int item) {
        i++;
        if (i <= n)
            sample ~= item;
        else if (uniform(0.0, 1.0) < (cast(double)n / i))
            sample[uniform(0, n)] = item;
        return sample;
    };
}

void main() {
    enum nRuns = 100_000;
    size_t[10] bin;

    foreach (trial; 0 .. nRuns) {
        auto sofn = sofN_creator(3);
        int[] sample;
        foreach (item; 0 .. bin.length)
            sample = sofn(item);
        foreach (s; sample)
            bin[s]++;
    }
    writefln("Item counts for %d runs:\n%s", nRuns, bin);
}
