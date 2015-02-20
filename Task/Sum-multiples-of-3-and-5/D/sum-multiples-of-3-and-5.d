import std.stdio, std.bigint;

BigInt sum35(in BigInt n) pure nothrow {
    static BigInt sumMul(in BigInt n, in int f) pure nothrow {
        immutable n1 = (n - 1) / f;
        return f * n1 * (n1 + 1) / 2;
    }

    return sumMul(n, 3) + sumMul(n, 5) - sumMul(n, 15);
}

void main() {
    1000.BigInt.sum35.writeln;
    (10.BigInt ^^ 20).sum35.writeln;
}
