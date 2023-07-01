import std.stdio, std.math, std.range, std.algorithm;

bool isPerfectNumber2(in int n) pure nothrow {
    if (n < 2)
        return false;

    int total = 1;
    foreach (immutable i; 2 .. cast(int)real(n).sqrt + 1)
        if (n % i == 0) {
            immutable int q = n / i;
            total += i;
            if (q > i)
                total += q;
        }

    return total == n;
}

void main() {
    10_000.iota.filter!isPerfectNumber2.writeln;
}
