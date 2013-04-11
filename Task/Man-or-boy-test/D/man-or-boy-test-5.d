import std.bigint, std.functional;

// Adapted from C code by Goran Weinholt, adapted from Knuth code.
BigInt A(in int k, in int x1, in int x2, in int x3,
       in int x4, in int x5) {
    static struct Inner {
        static BigInt _c1(in int k) {
            switch (k) {
                case 0: return BigInt(0);
                case 1: return BigInt(0);
                case 2: return BigInt(0);
                case 3: return BigInt(1);
                case 4: return BigInt(2);
                case 5: return BigInt(3);
                default: return c1(k - 1) + c2(k - 1);
            }
        }
        alias memoize!_c1 c1;

        static BigInt _c2(in int k) {
            switch (k) {
                case 0: return BigInt(0);
                case 1: return BigInt(0);
                case 2: return BigInt(1);
                case 3: return BigInt(1);
                case 4: return BigInt(1);
                case 5: return BigInt(2);
                default: return c2(k - 1) + c3(k - 1);
            }
        }
        alias memoize!_c2 c2;

        static BigInt _c3(in int k) {
            switch (k) {
                case 0: return BigInt(0);
                case 1: return BigInt(1);
                case 2: return BigInt(1);
                case 3: return BigInt(0);
                case 4: return BigInt(0);
                case 5: return BigInt(1);
                default: return c3(k - 1) + c4(k);
            }
        }
        alias memoize!_c3 c3;

        static BigInt _c4(in int k) {
            switch (k) {
                case 0: return BigInt(1);
                case 1: return BigInt(1);
                case 2: return BigInt(0);
                case 3: return BigInt(0);
                case 4: return BigInt(0);
                case 5: return BigInt(0);
                default: return c1(k - 1) + c4(k - 1) - 1;
            }
        }
        alias memoize!_c4 c4;

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
    foreach (i; 0 .. 40)
        writeln(i, " ", A(i, 1, -1, -1, 1, 0));

    writefln("...\n500 %-(%s\\\n     %)",
             std.range.chunks(dtext(A(500, 1, -1, -1, 1, 0)), 60));
}
