struct Ludics(T) {
    T[] rotor, taken = [T(1)];
    T i;
    size_t j;
    T front = 1; // = taken[0];
    bool running = false;
    static immutable bool empty = false;

    void popFront() pure nothrow @safe {
        if (running)
            goto RESUME;
        else
            running = true;

        i = 2;
        while (true) {
            j = 0;

            while (j < rotor.length) {
                rotor[j]--;
                if (!rotor[j])
                    break;
                j++;
            }
            if (j < rotor.length) {
                rotor[j] = taken[j + 1];
            } else {
                front = i;
                return;
        RESUME:
                taken ~= i;
                rotor ~= taken[j + 1];
            }
            i++; // Could overflow if T has a max.
        }
    }
}

void main() {
    import std.stdio, std.range, std.algorithm, std.array;

    Ludics!uint L;
    writeln("First 25 ludic primes:\n", L.take(25));
    writefln("\nThere are %d ludic numbers <= 1000.",
             L.until!q{ a > 1000 }.walkLength);

    writeln("\n2000'th .. 2005'th ludic primes:\n", L.drop(1999).take(6));

    enum uint m = 250;
    const few = L.until!(x => x > m).array;
    const triplets = few.filter!(x => x + 6 < m && few.canFind(x + 2)
                                      && few.canFind(x + 6))
                     // Ugly output:
                     //.map!(x => tuple(x, x + 2, x + 6)).array;
                     .map!(x => [x, x + 2, x + 6]).array;
    writefln("\nThere are %d triplets less than %d:\n%s",
             triplets.length, m, triplets);
}
