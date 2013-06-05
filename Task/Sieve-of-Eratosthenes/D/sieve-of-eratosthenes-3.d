import std.algorithm, std.bitmanip;

/// Extensible Sieve of Eratosthenes.
struct IsPrime {
    //__gshared static BitArray multiples = [true, true, false];
    __gshared static BitArray multiples;

    /*nothrow*/ static this() {
        multiples.init([true, true, false]);
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

version (sieve_of_eratosthenes3_main) {
    import std.stdio, std.range;

    void main() {
        50.iota.filter!IsPrime.writeln;
    }
}
