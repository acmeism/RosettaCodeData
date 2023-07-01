import std.stdio, std.range, std.algorithm;

void throwDie(in uint nSides, in uint nDice, in uint s, uint[] counts)
pure nothrow @safe @nogc {
    if (nDice == 0) {
        counts[s]++;
        return;
    }

    foreach (immutable i; 1 .. nSides + 1)
        throwDie(nSides, nDice - 1, s + i, counts);
}

real beatingProbability(uint nSides1, uint nDice1,
                        uint nSides2, uint nDice2)()
pure nothrow @safe /*@nogc*/ {
    uint[(nSides1 + 1) * nDice1] C1;
    throwDie(nSides1, nDice1, 0, C1);

    uint[(nSides2 + 1) * nDice2] C2;
    throwDie(nSides2, nDice2, 0, C2);

    immutable p12 = real((ulong(nSides1) ^^ nDice1) *
                         (ulong(nSides2) ^^ nDice2));

    return cartesianProduct(C1[].enumerate, C2[].enumerate)
           .filter!(p => p[0][0] > p[1][0])
           .map!(p => real(p[0][1]) * p[1][1] / p12)
           .sum;
}

void main() @safe {
    writefln("%1.16f", beatingProbability!(4, 9, 6, 6));
    writefln("%1.16f", beatingProbability!(10, 5, 7, 6));
}
