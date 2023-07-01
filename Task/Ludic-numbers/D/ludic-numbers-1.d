struct Ludics(T) {
    int opApply(int delegate(in ref T) dg) {
        int result;
        T[] rotor, taken = [T(1)];
        result = dg(taken[0]);
        if (result) return result;

        for (T i = 2; ; i++) { // Shoud be stopped if T has a max.
            size_t j = 0;
            for (; j < rotor.length; j++)
                if (!--rotor[j])
                    break;

            if (j < rotor.length) {
                rotor[j] = taken[j + 1];
            } else {
                result = dg(i);
                if (result) return result;
                taken ~= i;
                rotor ~= taken[j + 1];
            }
        }
    }
}

void main() {
    import std.stdio, std.range, std.algorithm;

    // std.algorithm.take can't be used here.
    uint[] L;
    foreach (const x; Ludics!uint())
        if (L.length < 2005)
            L ~= x;
        else
            break;

    writeln("First 25 ludic primes:\n", L.take(25));
    writefln("\nThere are %d ludic numbers <= 1000.",
             L.until!q{ a > 1000 }.walkLength);

    writeln("\n2000'th .. 2005'th ludic primes:\n", L[1999 .. 2005]);

    enum m = 250;
    const triplets = L.filter!(x => x + 6 < m &&
                                    L.canFind(x + 2) && L.canFind(x + 6))
                     // Ugly output:
                     //.map!(x => tuple(x, x + 2, x + 6)).array;
                     .map!(x => [x, x + 2, x + 6]).array;
    writefln("\nThere are %d triplets less than %d:\n%s",
             triplets.length, m, triplets);
}
