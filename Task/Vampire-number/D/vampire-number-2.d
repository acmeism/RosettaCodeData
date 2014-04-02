import std.stdio, std.math, std.algorithm, std.array, std.traits;

T[N] pows(T, size_t N)() {
    typeof(return) result;
    result[0] = 1;
    foreach (immutable i, ref r; result[1 .. $])
        r = result[i] * 10;
    return result;
}

__gshared immutable tenPowsU = pows!(uint, 10);
__gshared immutable tenPowsUL = pows!(ulong, 20);

size_t nDigits(T)(in T x) pure nothrow {
    Unqual!T y = x;
    size_t n = 0;
    while (y) {
        n++;
        y /= 10;
    }
    return n;
}

T dTally(T)(in T x) pure nothrow {
    Unqual!T y = x;
    T t = 0;
    while (y) {
        t += 1 << ((y % 10) * 6);
        y /= 10;
    }
    return t;
}

T[] fangs(T)(in T x, T[] f)
pure nothrow if (is(T == uint) || is(T == ulong)) {
    alias tenPows = Select!(is(T == ulong), tenPowsUL, tenPowsU);

    immutable nd0 = nDigits(x);
    if (nd0 & 1)
        return null;
    immutable nd = nd0 / 2;

    immutable lo = max(tenPows[nd - 1],
                       (x + tenPows[nd] - 2) / (tenPows[nd] - 1));
    immutable hi = min(x / lo, cast(T)sqrt(real(x)));
    immutable t = x.dTally;

    size_t n = 0;
    foreach (immutable a; lo .. hi + 1) {
        immutable b = x / a;
        if (a * b == x
            && (a % 10 || b % 10)
            && t == (a.dTally + b.dTally)) {
            f[n] = a;
            n++;
        }
    }

    return f[0 .. n];
}

void showFangs(T)(in T x, in T[] fs) {
    x.write;
    foreach (immutable fi; fs)
        writef(" = %d x %d", fi, x / fi);
    writeln;
}

void main() {
    uint[16] fu;
    for (uint x = 1, n = 0; n < 25; x++) {
        const fs = fangs(x, fu);
        if (fs.empty)
            continue;
        n++;
        writef("%2d: ", n);
        showFangs(x, fs);
    }
    writeln;

    __gshared static immutable ulong[3] bigs = [16_758_243_290_880UL,
                                                24_959_017_348_650UL,
                                                14_593_825_548_650UL];
    ulong[fu.length] ful;
    foreach (immutable bi; bigs) {
        const fs = fangs(bi, ful);
        if (fs.empty)
            writeln(bi, " is not vampiric");
        else
            showFangs(bi, fs);
    }
}
