import std.stdio, std.conv, std.string, std.algorithm, std.range;

void printChange(in uint tot, in uint[] coins)
in {
    assert(coins.isSorted);
} body {
    auto freqs = new uint[coins.length];

    void inner(in uint curTot, in size_t start) {
        if (curTot == tot)
            return writefln("%-(%s %)",
                            zip(coins, freqs)
                            .filter!(cf => cf[1] != 0)
                            .map!(cf => format("%u:%u", cf[])));

        foreach (immutable i; start .. coins.length) {
            immutable ci = coins[i];
            for (auto v = (freqs[i] + 1) * ci; v <= tot; v += ci)
                if (curTot + v <= tot) {
                    freqs[i] += v / ci;
                    inner(curTot + v, i + 1);
                    freqs[i] -= v / ci;
                }
        }
    }

    inner(0, 0);
}

void main() {
    printChange(1_00, [1, 5, 10, 25]);
}
