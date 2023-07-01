struct Taxicabs {
    alias CubesSumT = uint; // Or ulong.

    static struct Sum {
        CubesSumT value;
        uint x, y;
    }

    // The cubes can be pre-computed if CubesSumT is a BigInt.
    private uint nCubes;
    private Sum[] pq;
    private uint pq_len;

    private void addCube() pure nothrow @safe {
        nCubes = nCubes ? nCubes + 1 : 2;
        if (nCubes < 2)
            return; // 0 or 1 is useless.

        pq_len++;
        if (pq_len >= pq.length)
            pq.length = (pq.length == 0) ? 2 : (pq.length * 2);

        immutable tmp = Sum(CubesSumT(nCubes - 2) ^^ 3 + 1,
                            nCubes - 2, 1);

        // Upheap.
        uint i = pq_len;
        for (; i >= 1 && pq[i >> 1].value > tmp.value; i >>= 1)
            pq[i] = pq[i >> 1];

        pq[i] = tmp;
    }


    private void nextSum() pure nothrow @safe {
        while (!pq_len || pq[1].value >= (nCubes - 1) ^^ 3)
            addCube();

        Sum tmp = pq[0] = pq[1]; //pq[0] always stores last seen value.
        tmp.y++;
        if (tmp.y >= tmp.x) { // Done with this x; throw it away.
            tmp = pq[pq_len];
            pq_len--;
            if (!pq_len)
                return nextSum(); // Refill empty heap.
        } else
            tmp.value += tmp.y ^^ 3 - (tmp.y - 1) ^^ 3;

        // Downheap.
        uint i = 1;
        while (true) {
            uint j = i << 1;
            if (j > pq_len)
                break;
            if (j < pq_len && pq[j + 1].value < pq[j].value)
                j++;
            if (pq[j].value >= tmp.value)
                break;
            pq[i] = pq[j];
            i = j;
        }

        pq[i] = tmp;
    }


    Sum[] nextTaxi(size_t N)(ref Sum[N] hist)
    pure nothrow @safe {
        do {
            nextSum();
        } while (pq[0].value != pq[1].value);

        uint len = 1;
        hist[0] = pq[0];
        do {
            hist[len] = pq[1];
            len++;
            nextSum();
        } while (pq[0].value == pq[1].value);

        return hist[0 .. len];
    }
}


void main() nothrow {
    import core.stdc.stdio;

    Taxicabs t;
    Taxicabs.Sum[3] x;

    foreach (immutable uint i; 1 .. 2007) {
        const triples = t.nextTaxi(x);
        if (i > 25 && i < 2000)
            continue;
        printf("%4u: %10lu", i, triples[0].value);
        foreach_reverse (const s; triples)
            printf(" = %4u^3 + %4u^3", s.x, s.y);
        '\n'.putchar;
    }
}
