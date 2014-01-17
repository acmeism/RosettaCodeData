import std.stdio, std.bigint, std.algorithm, std.traits;

Unqual!T[] decompose(T)(in T number) pure /*nothrow*/
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
    foreach (immutable n; 2 .. 10)
        n.decompose.writeln;

    decompose(1023 * 1024).writeln;
    BigInt(2 * 3 * 5 * 7 * 11 * 11 * 13 * 17).decompose.writeln;
    decompose(16860167264933UL.BigInt * 179951).writeln;
    decompose(2.BigInt ^^ 100_000).group.writeln;
}
