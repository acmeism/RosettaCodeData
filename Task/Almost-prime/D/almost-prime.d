import std.stdio, std.algorithm, std.traits;

Unqual!T[] decompose(T)(in T number) pure nothrow
in {
    assert(number > 1);
} body {
    typeof(return) result;
    Unqual!T n = number;

    for (Unqual!T i = 2; n % i == 0; n /= i)
        result ~= i;
    for (Unqual!T i = 3; n >= i * i; i += 2)
        for (; n % i == 0; n /= i)
            result ~= i;

    if (n != 1)
        result ~= n;
    return result;
}

void main() {
    enum outLength = 10; // 10 k-th almost primes.

    foreach (immutable k; 1 .. 6) {
        writef("K = %d: ", k);
        auto n = 2; // The "current number" to be checked.
        foreach (immutable i; 1 .. outLength + 1) {
            while (n.decompose.length != k)
                n++;
            // Now n is K-th almost prime.
            write(n, " ");
            n++;
        }
        writeln;
    }
}
