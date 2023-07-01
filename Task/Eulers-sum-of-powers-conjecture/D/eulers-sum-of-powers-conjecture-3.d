import core.stdc.stdio, std.typecons, std.math, std.algorithm, std.range;

alias Pair = Tuple!(double, int);
alias PairPtr = Pair*;

// If less(x) is false, then less(x + 1) must also be false.
PairPtr huntForward(Pred)(PairPtr hint, const PairPtr end, const Pred less) pure nothrow @nogc {
    PairPtr result = hint;
    int step = 1;

    // Expanding phase.
    while (end - result > step) {
        PairPtr test = result + step;
        if (!less(test))
            break;
        result = test;
        step <<= 1;
    }

    // Contracting phase.
    while (step > 1) {
        step >>= 1;
        if (end - result <= step)
            continue;
        PairPtr test = result + step;
        if (less(test))
            result = test;
    }
    if (result != end && less(result))
        ++result;
    return result;
}


bool dPFind(int how_many) nothrow {
    enum MAX = 1_000;

    double[MAX] pow5;
    foreach (immutable i; 1 .. MAX)
        pow5[i] = double(i) ^^ 5;

    Pair[] diffs0; // Will contain (MAX-1) * (MAX-2) / 2 pairs.
    foreach (immutable i; 2 .. MAX)
        foreach (immutable j; 1 .. i)
            diffs0 ~= Pair(pow5[i] - pow5[j], j);

    // Remove pairs with duplicate first items.
    diffs0.length -= diffs0.sort!q{ a[0] < b[0] }.uniq.copy(diffs0).length;
    auto diffs = diffs0.assumeSorted!q{ a[0] < b[0] };

    foreach (immutable x4; 4 .. MAX - 1) {
        foreach (immutable x3; 3 .. x4) {
            immutable s2 = pow5[x4] + pow5[x3];
            auto pd0 = diffs[1 .. $].upperBound(Pair(s2, 0));
            PairPtr pd = &pd0[0] - 1;
            foreach (immutable x2; 2 .. x3) {
                immutable sum = s2 + pow5[x2];
                const PairPtr endPtr = &diffs[$ - 1] + 1;
                // This lambda heap-allocates.
                pd = huntForward(pd, endPtr, (in PairPtr p) pure => (*p)[0] < sum);
                if (pd != endPtr && (*pd)[0] == sum && (*pd)[1] < x3) { // Find each solution only once.
                    immutable y = ((*pd)[0] + pow5[(*pd)[1]]) ^^ 0.2;
                    printf("%d %d %d %d : %d\n", x4, x3, x2, (*pd)[1], cast(int)(y + 0.5));
                    if (--how_many <= 0)
                        return true;
                }
            }
        }
    }

    return false;
}


void main() nothrow {
    if (!dPFind(100))
        printf("Search finished.\n");
}
