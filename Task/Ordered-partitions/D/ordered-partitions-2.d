import core.stdc.stdio;

void genBits(size_t N)(ref uint[N] bits, in ref uint[N] parts,
                       uint mask, uint all, uint res, uint n, uint pid)
nothrow @nogc {
    static void showPart(in uint x) nothrow @nogc {
        '['.putchar;
        for (uint i = 0; (1 << i) <= x; i++)
            if (x & (1 << i))
                printf("%d ", i + 1);
        ']'.putchar;
    }

    while (!n) {
        bits[pid] = res;
        pid++;
        if (pid == N) {
            foreach (immutable b; bits)
                showPart(b);
            '\n'.putchar;
            return;
        }
        all &= ~res;
        mask = all;
        res = 0;
        n = parts[pid];
    }

    while (mask) {
        immutable uint i = mask & -int(mask);
        mask &= ~i;
        genBits(bits, parts, mask, all, res | i, n - 1, pid);
    }
}

void main() nothrow @nogc {
    immutable uint[3] parts = [2, 0, 2];
    uint m = 1;
    foreach (immutable p; parts)
        m <<= p;

    uint[parts.length] bits;
    genBits(bits, parts, m - 1, m - 1, 0, parts[0], 0);
}
