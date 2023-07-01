import std.stdio, std.range, std.algorithm, std.ascii;

enum uint nMax = 12;

__gshared char[] superperm;
__gshared uint pos;
__gshared uint[nMax] count;

/// factSum(n) = 1! + 2! + ... + n!
uint factSum(in uint n) pure nothrow @nogc @safe {
    return iota(1, n + 1).map!(m => reduce!q{ a * b }(1u, iota(1, m + 1))).sum;
}

bool r(in uint n) nothrow @nogc {
    if (!n)
        return false;

    immutable c = superperm[pos - n];
    if (!--count[n]) {
        count[n] = n;
        if (!r(n - 1))
            return false;
    }
    superperm[pos++] = c;
    return true;
}

void superPerm(in uint n) nothrow {
    static immutable chars = digits ~ uppercase;
    static assert(chars.length >= nMax);
    pos = n;
    superperm.length = factSum(n);

    foreach (immutable i; 0 .. n + 1)
        count[i] = i;
    foreach (immutable i; 1 .. n + 1)
        superperm[i - 1] = chars[i];

    while (r(n)) {}
}

void main() {
    foreach (immutable n; 0 .. nMax) {
        superPerm(n);
        writef("superPerm(%2d) len = %d", n, superperm.length);
        // Use -version=doPrint to see the string itself.
        version (doPrint) write(": ", superperm);
        writeln;
    }
}
