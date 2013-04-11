import std.traits: Unqual;

Unqual!T[] decompose(T)(T number) /*pure nothrow*/
in {
    assert(number > 1);
} body {
    alias UT = Unqual!T;
    typeof(return) result;
    UT n = number;

    for (UT i = 2; n % i == 0;) {
        result ~= i;
        n /= i;
    }
    for (UT i = 3; n >= i * i; i += 2) {
        while (n % i == 0) {
            result ~= i;
            n /= i;
        }
    }

    if (n != 1)
        result ~= n;
    return result;
}

void main() {
    import std.stdio, std.bigint, std.algorithm;

    foreach (immutable n; 2 .. 10)
        writeln(decompose(n));

    writeln(decompose(1023 * 1024));
    writeln(decompose(BigInt(2 * 3 * 5 * 7 * 11 * 11 * 13 * 17)));
    writeln(decompose(BigInt(16860167264933UL) * 179951));
    writeln(group(decompose(BigInt(2) ^^ 100_000)));
}
