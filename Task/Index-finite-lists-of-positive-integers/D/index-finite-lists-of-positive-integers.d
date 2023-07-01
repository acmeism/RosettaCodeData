import std.stdio, std.algorithm, std.array, std.conv, std.bigint;

BigInt rank(T)(in T[] x) pure /*nothrow*/ @safe {
    return BigInt("0x" ~ x.map!text.join('F'));
}

BigInt[] unrank(BigInt n) pure /*nothrow @safe*/ {
    string s;
    while (n) {
        s = "0123456789ABCDEF"[n % 16] ~ s;
        n /= 16;
    }
    return s.split('F').map!BigInt.array;
}

void main() {
    immutable s = [1, 2, 3, 10, 100, 987654321];
    s.writeln;
    s.rank.writeln;
    s.rank.unrank.writeln;
}
