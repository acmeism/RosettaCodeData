import std.stdio, std.range, std.algorithm, std.typecons, std.conv;

auto properDivisors(in ulong n) pure nothrow @safe /*@nogc*/ {
    return iota(1UL, (n + 1) / 2 + 1).filter!(x => n % x == 0 && n != x);
}

enum pDivsSum = (in ulong n) pure nothrow @safe /*@nogc*/ =>
    n.properDivisors.sum;

auto aliquot(in ulong n,
             in size_t maxLen=16,
             in ulong maxTerm=2UL^^47) pure nothrow @safe {
    if (n == 0)
        return tuple("Terminating", [0UL]);
    ulong[] s = [n];
    size_t sLen = 1;
    ulong newN = n;

    while (sLen <= maxLen && newN < maxTerm) {
        newN = s.back.pDivsSum;
        if (s.canFind(newN)) {
            if (s[0] == newN) {
                if (sLen == 1) {
                    return tuple("Perfect", s);
                } else if (sLen == 2) {
                    return tuple("Amicable", s);
                } else
                    return tuple(text("Sociable of length ", sLen), s);
            } else if (s.back == newN) {
                return tuple("Aspiring", s);
            } else
                return tuple(text("Cyclic back to ", newN), s);
        } else if (newN == 0) {
            return tuple("Terminating", s ~ 0);
        } else {
            s ~= newN;
            sLen++;
        }
    }

    return tuple("Non-terminating", s);
}

void main() {
    foreach (immutable n; 1 .. 11)
        writefln("%s: %s", n.aliquot[]);
    writeln;
    foreach (immutable n; [11, 12, 28, 496, 220, 1184,  12496, 1264460,
                           790, 909, 562, 1064, 1488])
        writefln("%s: %s", n.aliquot[]);
}
