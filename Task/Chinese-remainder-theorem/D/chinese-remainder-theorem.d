import std.stdio, std.algorithm;

T chineseRemainder(T)(in T[] n, in T[] a) pure nothrow @safe @nogc
in {
    assert(n.length == a.length);
} body {
    static T mulInv(T)(T a, T b) pure nothrow @safe @nogc {
        auto b0 = b;
        T x0 = 0, x1 = 1;
        if (b == 1)
            return T(1);
        while (a > 1) {
            immutable q = a / b;
            immutable amb = a % b;
            a = b;
            b = amb;
            immutable xqx = x1 - q * x0;
            x1 = x0;
            x0 = xqx;
        }
        if (x1 < 0)
            x1 += b0;
        return x1;
    }

    immutable prod = reduce!q{a * b}(T(1), n);

    T p = 1, sm = 0;
    foreach (immutable i, immutable ni; n) {
        p = prod / ni;
        sm += a[i] * mulInv(p, ni) * p;
    }
    return sm % prod;
}

void main() {
    immutable n = [3, 5, 7],
              a = [2, 3, 2];
    chineseRemainder(n, a).writeln;
}
