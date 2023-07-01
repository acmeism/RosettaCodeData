import std.algorithm : map;
import std.bigint;
import std.range;
import std.stdio;

BigInt factorial(BigInt n) {
    if (n == 0) return BigInt(1);
    BigInt res = 1;
    while (n > 0) {
        res *= n--;
    }
    return res;
}

BigInt lah(BigInt n, BigInt k) {
    if (k == 1) return factorial(n);
    if (k == n) return BigInt(1);
    if (k > n) return BigInt(0);
    if (k < 1 || n < 1) return BigInt(0);
    return (factorial(n) * factorial(n - 1)) / (factorial(k) * factorial(k - 1)) / factorial(n - k);
}

auto max(R)(R r) if (isInputRange!R) {
    alias T = ElementType!R;
    T v = T.init;

    while (!r.empty) {
        if (v < r.front) {
            v = r.front;
        }
        r.popFront;
    }

    return v;
}

void main() {
    writeln("Unsigned Lah numbers: L(n, k):");
    write("n/k ");
    foreach (i; 0..13) {
        writef("%10d ", i);
    }
    writeln();
    foreach (row; 0..13) {
        writef("%-3d", row);
        foreach (i; 0..row+1) {
            auto l = lah(BigInt(row), BigInt(i));
            writef("%11d", l);
        }
        writeln();
    }
    writeln("\nMaximum value from the L(100, *) row:");
    auto lambda = (int a) => lah(BigInt(100), BigInt(a));
    writeln(iota(0, 100).map!lambda.max);
}
