import std.random;

bool isProbablePrime(in ulong n, in uint k=10) /*nothrow*/ @safe /*@nogc*/ {
    static ulong modPow(ulong b, ulong e, in ulong m)
    pure nothrow @safe @nogc {
        ulong result = 1;
        while (e > 0) {
            if ((e & 1) == 1)
                result = (result * b) % m;
            b = (b ^^ 2) % m;
            e >>= 1;
        }
        return result;
    }

    if (n < 2 || n % 2 == 0)
        return n == 2;

    ulong d = n - 1;
    ulong s = 0;
    while (d % 2 == 0) {
        d /= 2;
        s++;
    }
    assert(2 ^^ s * d == n - 1);

    outer:
    foreach (immutable _; 0 .. k) {
        immutable ulong a = uniform(2, n);
        ulong x = modPow(a, d, n);
        if (x == 1 || x == n - 1)
            continue;
        foreach (immutable __; 1 .. s) {
            x = modPow(x, 2, n);
            if (x == 1)
                return false;
            if (x == n - 1)
                continue outer;
        }
        return false;
    }

    return true;
}

void main() { // Demo code.
    import std.stdio, std.range, std.algorithm;

    iota(2, 30).filter!isProbablePrime.writeln;
}
