import std.stdio, std.bigint, std.conv;

BigInt ipow(BigInt base, BigInt exp) pure /*nothrow*/ {
    auto result = 1.BigInt;
    while (exp) {
        if (exp & 1)
            result *= base;
        exp >>= 1;
        base *= base;
    }

    return result;
}

BigInt ackermann(in int m, in int n) pure /*nothrow*/
in {
    assert(m >= 0 && n >= 0);
} out(result) {
    assert(result >= 0);
} body {
    static BigInt ack(in int m, in BigInt n) pure /*nothrow*/ {
        switch (m) {
            case 0: return n + 1;
            case 1: return n + 2;
            case 2: return 3 + 2 * n;
            //case 3: return 5 + 8 * (2 ^^ n - 1);
            case 3: return 5 + 8 * (ipow(2.BigInt, n) - 1);
            default: if (n == 0)
                        return ack(m - 1, 1.BigInt);
                     else
                        return ack(m - 1, ack(m, n - 1));
        }
    }

    return ack(m, n.BigInt);
}

void main() {
    foreach (immutable m; 1 .. 4)
        foreach (immutable n; 1 .. 9)
            writefln("ackermann(%d, %d): %s", m, n, ackermann(m, n));
    writefln("ackermann(4, 1): %s", ackermann(4, 1));

    immutable a = ackermann(4, 2).text;
    writefln("ackermann(4, 2)) (%d digits):\n%s...\n%s",
             a.length, a[0 .. 94], a[$ - 96 .. $]);
}
