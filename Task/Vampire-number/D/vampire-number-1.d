import std.stdio, std.algorithm, std.range, std.array;

immutable(long[2])[] vampireNumberFactors(in long n) {

    static typeof(return) factorPairs(in long k) pure nothrow {
        typeof(return) pairs;
        foreach (immutable i; 2 .. cast(long)(k ^^ 0.5 + 1))
            if (k % i == 0) {
                immutable q = k / i;
                if (q > i)
                    pairs ~= [i, q]; // Heap-allocated pair.
            }
        return pairs;
    }

    static long[] getDigits(in long k) pure nothrow {
        typeof(return) digits;
        long m = k;
        while (m > 0) {
            digits ~= (m % 10);
            m /= 10;
        }
        digits.reverse();
        return digits;
    }

    if (n < 2)
        return null;

    auto digits = getDigits(n);
    if (digits.length % 2 != 0)
        return null;
    digits.sort();

    typeof(return) result;
    immutable half = digits.length / 2;

    foreach (immutable pair; factorPairs(n)) {
        /*immutable*/ auto f1 = getDigits(pair.front);
        if (f1.length != half)
            continue;

        immutable f2 = getDigits(pair.back);
        if (f2.length != half)
            continue;

        if (f1.back == 0 && f2.back == 0)
            continue;

        if (!(f1 ~ f2).sort().equal(digits))
            continue;

        result ~= pair;
    }

    return result;
}

void main() {
    for (long count = 0, n = 0; count < 25; n++) {
        immutable factors = vampireNumberFactors(n);
        if (!factors.empty) {
            writefln("%s : %(%s %)", n, factors);
            count++;
        }
    }

    writeln;
    foreach (immutable n; [16_758_243_290_880L,
                           24_959_017_348_650L,
                           14_593_825_548_650L]) {
        immutable factors = vampireNumberFactors(n);
        if (!factors.empty)
            writefln("%s: %(%s %)", n, vampireNumberFactors(n));
    }
}
