import std.stdio, std.bigint;

T binomial(T)(/*in*/ T n, T k) /*pure nothrow*/ {
    if (k > (n / 2))
        k = n - k;
    T bc = 1;
    foreach (T i; cast(T)2 .. k + 1)
        bc = (bc * (n - k + i)) / i;
    return bc;
}

void main() {
    foreach (d; [[5, 3], [100, 2], [100, 98]])
        writefln("(%3d %3d) = %s", d[0], d[1], binomial(d[0], d[1]));
    writeln("(100  50) = ", binomial(BigInt(100), BigInt(50)));
}
