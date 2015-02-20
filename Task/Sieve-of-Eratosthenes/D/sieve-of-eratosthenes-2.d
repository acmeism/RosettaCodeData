import std.stdio, std.math, std.array;

size_t[] sieve(in size_t m) pure nothrow @safe {
    if (m < 3)
        return null;
    immutable size_t n = m - 1;
    enum size_t bpc = size_t.sizeof * 8;
    auto F = new size_t[((n + 2) / 2) / bpc + 1];
    F[] = size_t.max;

    size_t isSet(in size_t i) nothrow @safe @nogc {
        immutable size_t offset = i / bpc;
        immutable size_t mask = 1 << (i % bpc);
        return F[offset] & mask;
    }

    void resetBit(in size_t i) nothrow @safe @nogc {
        immutable size_t offset = i / bpc;
        immutable size_t mask = 1 << (i % bpc);
        if ((F[offset] & mask) != 0)
            F[offset] = F[offset] ^ mask;
    }

    for (size_t i = 3; i <= sqrt(real(n)); i += 2)
        if (isSet((i - 3) / 2))
            for (size_t j = i * i; j <= n; j += 2 * i)
                resetBit((j - 3) / 2);

    Appender!(size_t[]) result;
    result ~= 2;
    for (size_t i = 3; i <= n; i += 2)
        if (isSet((i - 3) / 2))
            result ~= i;
    return result.data;
}

void main() {
    50.sieve.writeln;
}
