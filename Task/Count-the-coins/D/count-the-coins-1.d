import std.stdio, std.bigint;

auto changes(int amount, int[] coins) {
    auto ways = new BigInt[amount + 1];
    ways[0] = 1;
    foreach (coin; coins)
        foreach (j; coin .. amount+1)
            ways[j] += ways[j - coin];
    return ways[amount];
}

void main() {
    writeln(changes(   1_00, [25, 10, 5, 1]));
    writeln(changes(1000_00, [100, 50, 25, 10, 5, 1]));
}
