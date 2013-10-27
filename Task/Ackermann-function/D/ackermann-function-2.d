import std.stdio, std.bigint, std.conv;

/*pure nothrow*/ BigInt ipow(/*in*/ BigInt base, /*in*/ BigInt exp){
    auto result = BigInt(1);
    //while (exp) {
    while (exp != 0) {
        //if (exp & 1)
        if (exp % 2)
            result *= base;
        exp >>= 1;
        base *= base;
    }

    return result;
}

/*pure nothrow*/ BigInt ackermann(in int m, in int n)
in {
    assert(m >= 0 && n >= 0);
} out(result) {
    //assert(result >= 0);
    //assert(cast()result >= 0);
} body {
    /*pure nothrow*/ static BigInt ack(in int m, /*in*/ BigInt n) {
        switch (m) {
            case 0: return n + 1;
            case 1: return n + 2;
            case 2: return 3 + 2 * n;
            //case 3: return 5 + 8 * (2 ^^ n - 1);
            case 3: return 5 + 8 * (ipow(BigInt(2), n) - 1);
            default: if (n == 0)
                        return ack(m - 1, BigInt(1));
                     else
                        return ack(m - 1, ack(m, n - 1));
        }
    }

    return ack(m, BigInt(n));
}

void main() {
    foreach (m; 1 .. 4)
        foreach (n; 1 .. 9)
            writefln("ackermann(%d, %d): %s", m, n, ackermann(m, n));
    writefln("ackermann(4, 1): %s", ackermann(4, 1));

    auto a = text(ackermann(4, 2));
    writefln("ackermann(4, 2)) (%d digits):\n%s...\n%s",
             a.length, a[0 .. 94], a[$-96 .. $]);
}
