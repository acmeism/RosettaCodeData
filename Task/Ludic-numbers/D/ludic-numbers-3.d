void main() {
    import std.stdio, std.range, std.algorithm, std.concurrency;

    Generator!T ludics(T)() {
        return new typeof(return)({
            T[] rotor, taken = [T(1)];
            yield(taken[0]);

            for (T i = 2; ; i++) { // Shoud be stopped if T has a max.
                size_t j = 0;
                for (; j < rotor.length; j++)
                    if (!--rotor[j])
                        break;

                if (j < rotor.length) {
                    rotor[j] = taken[j + 1];
                } else {
                    yield(i);
                    taken ~= i;
                    rotor ~= taken[j + 1];
                }
            }
        });
    }

    const L = ludics!uint.take(2005).array;

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
