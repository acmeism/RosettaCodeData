import std.stdio, std.math, std.conv, std.algorithm,
       std.array, std.string, import xt.uiprimes;

pragma(lib, "uiprimes.lib");

// function _factorize_ included in uiprimes.lib
ulong[] factorize(ulong n) {
    if (n == 0) return [];
    if (n == 1) return [1];
    ulong[] res;
    uint limit = cast(uint)(1 + sqrt(n));
    foreach (p; Primes(limit)) {
        if (n == 1) break;
        if (0UL == (n % p))
            while((n > 1) && (0UL == (n % p ))) {
                res ~= p;
                n /= p;
            }
    }
    if (n > 1)
        res ~= [n];
    return res;
}

string productStr(T)(in T[] nums) {
    return nums.map!text().join(" x ");
}

void main() {
    foreach (i; 1 .. 21)
        writefln("%2d = %s", i, productStr(factorize(i)));
}
