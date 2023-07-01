import std.stdio, std.algorithm, std.range, std.bitmanip;

/// Not extendible Sieve of Eratosthenes.
BitArray sieve(in uint n) pure nothrow /*@safe*/ {
    BitArray composites;
    composites.init([true, true]);
    composites.length = n;
    if (n < 2)
        return composites;

    foreach (immutable uint i; 2 .. cast(uint)(n ^^ 0.5) + 1)
        if (!composites[i])
            for (uint k = i * i; k < n; k += i)
                composites[k] = true;

    return composites;
}

__gshared BitArray composites;

bool isEmirp(uint n) nothrow @nogc {
    uint reverse(uint n) pure nothrow @safe @nogc {
        uint r;
        for (r = 0; n; n /= 10)
            r = r * 10 + (n % 10);
        return r;
    }

    immutable r = reverse(n);
    // BitArray doesn't perform bound tests yet.
    assert(n < composites.length && r < composites.length);
    return r != n && !composites[n] && !composites[r];
}

void main() {
    composites = 1_000_000.sieve;

    auto uints = uint.max.iota;
    writeln("First 20:\n", uints.filter!isEmirp.take(20));
    writeln("Between 7700 and 8000:\n",
            iota(7_700, 8_001).filter!isEmirp);
    writeln("10000th: ", uints.filter!isEmirp.drop(9_999).front);
}
