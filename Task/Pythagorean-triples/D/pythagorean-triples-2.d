import std.stdio;

alias uint xuint; // ulong if going over 1 billion.

__gshared xuint nTriples, nPrimitives, limit;

void countTriples(xuint x, xuint y, xuint z) nothrow {
    while (true) {
        immutable xuint p = x + y + z;
        if (p > limit)
            return;

        nPrimitives++;
        nTriples += limit / p;

        xuint t0 = x - 2 * y + 2 * z;
        xuint t1 = 2 * x - y + 2 * z;
        xuint t2 = t1 - y + z;
        countTriples(t0, t1, t2);

        t0 += 4 * y;
        t1 += 2 * y;
        t2 += 4 * y;
        countTriples(t0, t1, t2);

        z = t2 - 4 * x;
        y = t1 - 4 * x;
        x = t0 - 2 * x;
    }
}

void main() {
    foreach (p; 1 .. 9) {
        limit = (cast(xuint)10) ^^ p;
        nTriples = nPrimitives = 0;
        countTriples(3, 4, 5);
        writefln("Up to %11d: %11d triples, %9d primitives.",
                 limit, nTriples, nPrimitives);
    }
}
