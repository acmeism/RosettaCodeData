import std.bigint, std.functional;

// Adapted from C code by Goran Weinholt, adapted from Knuth code.
BigInt A(in int k, in int x1, in int x2, in int x3,
         in int x4, in int x5) {
    static struct Inner {
        static BigInt c1_(in int k) {
            if (k > 5)
                return c1(k - 1) + c2(k - 1);
            static immutable t = [0, 0, 0, 1, 2, 3];
            return t[k].BigInt;
        }
        alias c1 = memoize!c1_;

        static BigInt c2_(in int k) {
            if (k > 5)
                return c2(k - 1) + c3(k - 1);
            static immutable t = [0, 0, 1, 1, 1, 2];
            return t[k].BigInt;
        }
        alias c2 = memoize!c2_;

        static BigInt c3_(in int k) {
            if (k > 5)
                return c3(k - 1) + c4(k);
            static immutable t = [0, 1, 1, 0, 0, 1];
            return t[k].BigInt;
        }
        alias c3 = memoize!c3_;

        static BigInt c4_(in int k) {
            if (k > 5)
                return c1(k - 1) + c4(k - 1) - 1;
            static immutable t = [1, 1, 0, 0, 0, 0];
            return t[k].BigInt;
        }
        alias c4 = memoize!c4_;

        static int c5(in int k) pure nothrow {
            return !!k;
        }
    }

    with (Inner)
        return c1(k) * x1 + c2(k) * x2 + c3(k) * x3 +
               c4(k) * x4 + c5(k) * x5;
}

void main() {
    import std.stdio, std.conv, std.range;

    foreach (immutable i; 0 .. 40)
        writeln(i, " ", A(i, 1, -1, -1, 1, 0));

    writefln("...\n500 %-(%s\\\n     %)",
             A(500, 1, -1, -1, 1, 0).text.chunks(60));
}
