import std.stdio, std.bigint, std.functional;

BigInt factorial(uint n) {
    alias memoize!factorial mfact;
    return n ? mfact(n - 1) * n : BigInt(1);
}

auto cats1(uint n) {
    return factorial(2 * n) / (factorial(n + 1) * factorial(n));
}

BigInt cats2(uint n) {
    alias memoize!cats2 mcats2;
    if (n == 0) return BigInt(1);
    auto sum = BigInt(0);
    foreach (i; 0 .. n)
        sum += mcats2(i) * mcats2(n - 1 - i);
    return sum;
}

BigInt cats3(uint n) {
    alias memoize!cats3 mcats3;
    return n ? (4*n - 2) * mcats3(n - 1) / (n + 1) : BigInt(1);
}

void main() {
    foreach (i; 0 .. 15)
        writefln("%2d => %s %s %s", i, cats1(i), cats2(i), cats3(i));
}
