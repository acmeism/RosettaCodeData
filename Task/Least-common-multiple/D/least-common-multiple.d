import std.stdio, std.bigint;

T lcm(T)(/*in*/ T m, /*in*/ T n) /*pure nothrow*/ {
    if (m == 0) return m;
    if (n == 0) return n;
    T r = (m * n) / gcd(m, n);
    //return abs(r);
    return (r < 0) ? -r : r;
}

T gcd(T)(/*in*/ T a, /*in*/ T b) /*pure nothrow*/ {
    while (b != 0) {
        auto t = b;
        b = a % b;
        a = t;
    }
    return a;
}

void main() {
    writeln(lcm(12, 18));
    writeln(lcm(BigInt("2562047788015215500854906332309589561"),
                BigInt("6795454494268282920431565661684282819")));
}
