import std.stdio, std.bigint, std.algorithm;

struct Names {
    BigInt[] p = [1.BigInt];

    int opApply(int delegate(ref immutable int, ref BigInt) dg) {
        int result;

        foreach (immutable n; 1 .. int.max) {
            p.assumeSafeAppend;
            p ~= 0.BigInt;

            foreach (immutable k; 1 .. n + 1) {
                auto d = n - k * (3 * k - 1) / 2;
                if (d < 0)
                    break;

                if (k & 1)
                    p[n] += p[d];
                else
                    p[n] -= p[d];

                d -= k;
                if (d < 0)
                    break;

                if (k & 1)
                    p[n] += p[d];
                else
                    p[n] -= p[d];
            }

            result = dg(n, p[n]);
            if (result) break;
        }

        return result;
    }
}

void main() {
    immutable ns = [23:0, 123:0, 1234:0, 12345:0];
    immutable maxNs = ns.byKey.reduce!max;

    foreach (immutable i, p; Names()) {
        if (i > maxNs)
            break;
        if (i in ns)
            writefln("%6d: %s", i, p);
    }
}
