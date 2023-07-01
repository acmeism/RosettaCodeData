import std.algorithm;
import std.array;
import std.bigint;
import std.range;
import std.stdio;

void main() {
    foreach (n; chain(iota(1, 11), iota(95, 106), only(297, 576, 594, 891, 909, 999, 1998, 2079, 2251, 2277, 2439, 2997, 4878))) {
        auto result = getA004290(n);
        writefln("A004290(%d) = %s = %s * %s", n, result, n, result / n);
    }
}

BigInt getA004290(int n) {
    if (n == 1) {
        return BigInt(1);
    }
    auto L = uninitializedArray!(int[][])(n, n);
    foreach (i; 2..n) {
        L[0][i] = 0;
    }
    L[0][0] = 1;
    L[0][1] = 1;
    int m = 0;
    BigInt ten = 10;
    BigInt nBi = n;
    while (true) {
        m++;
        if (L[m - 1][mod(-(ten ^^ m), nBi).toInt] == 1) {
            break;
        }
        L[m][0] = 1;
        foreach (k; 1..n) {
            L[m][k] = max(L[m - 1][k], L[m - 1][mod(BigInt(k) - (ten ^^ m), nBi).toInt]);
        }
    }
    auto r = ten ^^ m;
    auto k = mod(-r, nBi);
    foreach_reverse (j; 1 .. m) {
        assert(j != m);
        if (L[j - 1][k.toInt] == 0) {
            r += ten ^^ j;
            k = mod(k - (ten ^^ j), nBi);
        }
    }
    if (k == 1) {
        r++;
    }
    return r;
}

BigInt mod(BigInt m, BigInt n) {
    auto result = m % n;
    if (result < 0) {
        result += n;
    }
    return result;
}
