import std.stdio, std.range, std.algorithm;

ulong[ulong] factor(ulong n) {
    ulong[ulong] res;
    int e;

    for (int p = 2; p * p <= n; p++) {
        for (e = 0; n % p == 0; n /= p) e++;
        if (e > 0) res[p] = e;
    }
    if (n != 1) res[n] = 1;
    return res;
}

ulong factorialPrimeExponent(ulong k, ulong p) {
    ulong res = 0;
    while (k > 0) {
         k = k / p;
         res += k;
    }
    return res;
}

bool factorialDivisibleByNumber(ulong kFac, ulong n) {
    foreach (p, e; factor(n))
        if (e > factorialPrimeExponent(kFac, p))
            return false;
    return true;
}

ulong kempner(ulong n) {
    if (n == 1) return 1;
    ulong k = factor(n).keys.maxElement;
    while (!factorialDivisibleByNumber(k, n)) k++;
    return k;
}

void main() {
    writeln("First fifty Kempner numbers:");
    writefln("%(%(%4d %)\n%)\n", iota(1,51).map!kempner.chunks(10));

    foreach (n; 77135679311..77135679322)
        writefln("S(%d) = %d", n, kempner(n));
}
