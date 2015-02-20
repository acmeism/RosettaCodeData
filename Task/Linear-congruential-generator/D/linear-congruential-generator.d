struct LinearCongruentialGenerator {
    enum uint RAND_MAX = (1U << 31) - 1;
    uint seed = 0;

    uint randBSD() pure nothrow @nogc {
        seed = (seed * 1_103_515_245 + 12_345) & RAND_MAX;
        return seed;
    }

    uint randMS() pure nothrow @nogc {
        seed = (seed * 214_013 + 2_531_011) & RAND_MAX;
        return seed >> 16;
    }
}

void main() {
    import std.stdio;

    LinearCongruentialGenerator rnd;

    foreach (immutable i; 0 .. 10)
        writeln(rnd.randBSD);
    writeln;

    rnd.seed = 0;
    foreach (immutable i; 0 .. 10)
        writeln(rnd.randMS);
}
