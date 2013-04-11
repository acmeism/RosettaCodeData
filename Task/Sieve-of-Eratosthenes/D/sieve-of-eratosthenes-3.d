import std.algorithm, std.bitmanip;

/// Extensible Sieve of Eratosthenes.
struct IsPrime {
    //__gshared static BitArray multiples = [true, true, false];
    __gshared static BitArray multiples;

    static this() {
        multiples.length = 3;
        multiples[0] = true;
        multiples[1] = true;
    }

    static bool opCall(in size_t n) /*nothrow*/ {
        if (n >= multiples.length) {
            // Extend the sieve.
            immutable oldLen = multiples.length; // Not nothrow.
            immutable newMax = max((oldLen - 1) * 2, n);
            multiples.length = newMax + 1;
            foreach (immutable p; 2 .. oldLen)
                if (!multiples[p])
                    for (size_t i = p * ((oldLen + p) / p);
                         i < newMax + 1; i += p)
                            multiples[i] = true;
            foreach (immutable i; oldLen .. newMax + 1)
                if (!multiples[i])
                    for (size_t j = i * 2; j < newMax + 1; j += i)
                        multiples[j] = true;
        }
        return !multiples[n];
    }
}

version (eratosthenes3_main) {
    import std.stdio, std.range;
    void main() {
        // iota(50).filter!IsPrime().writeln();
        iota(50).filter!(i => IsPrime(i))().writeln();
    }
}
