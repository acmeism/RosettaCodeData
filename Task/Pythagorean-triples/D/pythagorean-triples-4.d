import std.stdio;

alias Xuint = uint; // ulong if going over 1 billion.

__gshared Xuint nTriples, nPrimitives, limit;

void countTriples(Xuint x, Xuint y, Xuint z) nothrow @nogc {
    while (true) {
        immutable p = x + y + z;
        if (p > limit)
            return;

        nPrimitives++;
        nTriples += limit / p;

        auto t0 = x - 2 * y + 2 * z;
        auto t1 = 2 * x - y + 2 * z;
        auto t2 = t1 - y + z;
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
    foreach (immutable p; 1 .. 9) {
        limit = Xuint(10) ^^ p;
        nTriples = nPrimitives = 0;
        countTriples(3, 4, 5);
        writefln("Up to %11d: %11d triples, %9d primitives.",
                 limit, nTriples, nPrimitives);
    }
}
