import std.stdio, std.algorithm, std.range, std.ascii, std.string;

auto longMult(in string x1, in string x2) pure nothrow @safe {
    auto digits1 = x1.representation.retro.map!q{a - '0'};
    immutable digits2 = x2.representation.retro.map!q{a - '0'}.array;
    uint[] res;

    foreach (immutable i, immutable d1; digits1.enumerate) {
        foreach (immutable j, immutable d2; digits2) {
            immutable k = i + j;
            if (res.length <= k)
                res.length++;
            res[k] += d1 * d2;

            if (res[k] > 9) {
                if (res.length <= k + 1)
                    res.length++;
                res[k + 1] = res[k] / 10 + res[k + 1];
                res[k] -= res[k] / 10 * 10;
            }
        }
    }

    //return res.retro.map!digits;
    return res.retro.map!(d => digits[d]);
}

void main() {
    immutable two64 = "18446744073709551616";
    longMult(two64, two64).writeln;
}
