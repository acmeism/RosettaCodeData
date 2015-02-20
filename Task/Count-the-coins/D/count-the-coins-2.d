import std.stdio, core.checkedint;

auto changes(int amount, int[] coins, ref bool overflow) {
    auto ways = new ulong[amount + 1];
    ways[0] = 1;
    foreach (coin; coins)
        foreach (j; coin .. amount + 1)
            ways[j] = ways[j].addu(ways[j - coin], overflow);
    return ways[amount];
}

void main() {
    bool overflow = false;
    changes(    1_00, [25, 10, 5, 1], overflow).writeln;
    if (overflow)
        "Overflow".puts;
    overflow = false;
    changes( 1000_00, [100, 50, 25, 10, 5, 1], overflow).writeln;
    if (overflow)
        "Overflow".puts;
}
