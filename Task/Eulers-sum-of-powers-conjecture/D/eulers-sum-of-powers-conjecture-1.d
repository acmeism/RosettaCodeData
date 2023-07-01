import std.stdio, std.range, std.algorithm, std.typecons;

auto eulersSumOfPowers() {
    enum maxN = 250;
    auto pow5 = iota(size_t(maxN)).map!(i => ulong(i) ^^ 5).array.assumeSorted;

    foreach (immutable x0; 1 .. maxN)
        foreach (immutable x1; 1 .. x0)
            foreach (immutable x2; 1 .. x1)
                foreach (immutable x3; 1 .. x2) {
                    immutable powSum = pow5[x0] + pow5[x1] + pow5[x2] + pow5[x3];
                    if (pow5.contains(powSum))
                        return tuple(x0, x1, x2, x3, pow5.countUntil(powSum));
                }
    assert(false);
}

void main() {
    writefln("%d^5 + %d^5 + %d^5 + %d^5 == %d^5", eulersSumOfPowers[]);
}
