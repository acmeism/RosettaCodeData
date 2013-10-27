import std.stdio, std.bigint, std.algorithm, std.range, core.memory;

auto hamming(in int n) {
    BigInt two = 2, three = 3, five = 5;
    auto h = new BigInt[n];
    h[0] = 1;
    BigInt x2 = 2, x3 = 3, x5 = 5;
    int i, j, k;

    foreach (ref el; h[1 .. $]) {
        el = min(x2, x3, x5);
        if (el == x2) x2 = two   * h[++i];
        if (el == x3) x3 = three * h[++j];
        if (el == x5) x5 = five  * h[++k];
    }
    return h.back;
}

void main() {
    GC.disable;
    iota(1, 21).map!hamming.writeln;
    1_691.hamming.writeln;
    1_000_000.hamming.writeln;
}
