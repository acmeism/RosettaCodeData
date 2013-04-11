import std.stdio, std.algorithm, std.range;

auto longMult(in string x, in string y) /*pure nothrow*/ {
    auto digits1 = x.retro().map!q{a - '0'}();
    const digits2 = y.retro().map!q{a - '0'}().array();
    int[] res;

    foreach (i, d1; int.max.iota().zip(digits1))
        foreach (j, d2; digits2) {
            immutable int k = i + j;
            if (res.length <= k)
                res.length += 1;
            res[k] += d1 * d2;

            if (res[k] > 9) {
                if (res.length <= k + 1)
                    res.length += 1;
                res[k + 1] = res[k] / 10 + res[k + 1];
                res[k] -= res[k] / 10 * 10;
            }
        }

    return res.retro().map!q{ cast(char)(a + '0') }();
}

void main() {
    immutable two64 = "18446744073709551616";
    writeln(longMult(two64, two64));
}
