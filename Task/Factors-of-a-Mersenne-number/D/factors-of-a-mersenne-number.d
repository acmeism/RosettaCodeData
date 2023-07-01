import std.stdio, std.math, std.traits;

ulong mersenneFactor(in ulong p) pure nothrow @nogc {
    static bool isPrime(T)(in T n) pure nothrow @nogc {
        if (n < 2 || n % 2 == 0)
            return n == 2;
        for (Unqual!T i = 3; i ^^ 2 <= n; i += 2)
            if (n % i == 0)
                return false;
        return true;
    }

    static ulong modPow(in ulong cb, in ulong ce,in ulong m)
    pure nothrow @nogc {
        ulong b = cb;
        ulong result = 1;
        for (ulong e = ce; e > 0; e >>= 1) {
            if ((e & 1) == 1)
                result = (result * b) % m;
            b = (b ^^ 2) % m;
        }
        return result;
    }

    immutable ulong limit = p <= 64 ? cast(ulong)(real(2.0) ^^ p - 1).sqrt : uint.max; // prevents silent overflows
    for (ulong k = 1; (2 * p * k + 1) < limit; k++) {
        immutable ulong q = 2 * p * k + 1;
        if ((q % 8 == 1 || q % 8 == 7) && isPrime(q) &&
            modPow(2, p, q) == 1)
            return q;
    }
    return 1; // returns a sensible smallest factor
}

void main() {
    writefln("Factor of M929: %d", 929.mersenneFactor);
}
