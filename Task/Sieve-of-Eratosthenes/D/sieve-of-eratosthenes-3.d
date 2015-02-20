/// Extensible Sieve of Eratosthenes.
struct Prime {
    uint[] a = [2];

    private void grow() pure nothrow @safe {
        immutable p0 = a[$ - 1] + 1;
        auto b = new bool[p0];

        foreach (immutable di; a) {
            immutable uint i0 = p0 / di * di;
            uint i = (i0 < p0) ? i0 + di - p0 : i0 - p0;
            for (; i < b.length; i += di)
                b[i] = true;
        }

        foreach (immutable uint i, immutable bi; b)
            if (!b[i])
                a ~= p0 + i;
    }

    uint opCall(in uint n) pure nothrow @safe {
        while (n >= a.length)
            grow;
        return a[n];
    }
}

version (sieve_of_eratosthenes3_main) {
    void main() {
        import std.stdio, std.range, std.algorithm;

        Prime prime;
        uint.max.iota.map!prime.until!q{a > 50}.writeln;
    }
}
