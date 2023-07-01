import std.array;
import std.math;
import std.stdio;

long[] sieve(long limit) {
    long[] primes = [2];
    bool[] c = uninitializedArray!(bool[])(cast(size_t)(limit + 1));
    long p = 3;
    while (true) {
        long p2 = p * p;
        if (p2 > limit) {
            break;
        }
        for (long i = p2; i <= limit; i += 2 * p) {
            c[cast(size_t)i] = true;
        }
        while (true) {
            p += 2;
            if (!c[cast(size_t)p]) {
                break;
            }
        }
    }
    for (long i = 3; i <= limit; i += 2) {
        if (!c[cast(size_t)i]) {
            primes ~= i;
        }
    }
    return primes;
}

long[] squareFree(long from, long to) {
    long limit = cast(long)sqrt(cast(real)to);
    auto primes = sieve(limit);
    long[] results;

    outer:
    for (long i = from; i <= to; i++) {
        foreach (p; primes) {
            long p2 = p * p;
            if (p2 > i) {
                break;
            }
            if (i % p2 == 0) {
                continue outer;
            }
        }
        results ~= i;
    }

    return results;
}

enum TRILLION = 1_000_000_000_000L;

void main() {
    writeln("Square-free integers from 1 to 145:");
    auto sf = squareFree(1, 145);
    foreach (i,v; sf) {
        if (i > 0 && i % 20 == 0) {
            writeln;
        }
        writef("%4d", v);
    }

    writefln("\n\nSquare-free integers from %d to %d:", TRILLION, TRILLION + 145);
    sf = squareFree(TRILLION, TRILLION + 145);
    foreach (i,v; sf) {
        if (i > 0 && i % 5 == 0) {
            writeln;
        }
        writef("%14d", v);
    }

    writeln("\n\nNumber of square-free integers:");
    foreach (to; [100, 1_000, 10_000, 100_000, 1_000_000]) {
        writefln("   from 1 to %d = %d", to, squareFree(1, to).length);
    }
}
