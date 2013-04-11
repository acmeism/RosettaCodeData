import std.stdio, std.math, std.bigint;

bool isPrime(int p) pure nothrow {
    if (p < 2 || p % 2 == 0)
        return p == 2;
    foreach (i; 3 .. cast(uint)(sqrt(cast(real)p)) + 1)
        if (p % i == 0)
            return false;
    return true;
}

bool isMersennePrime(int p) /*pure nothrow*/ {
    if (!isPrime(p))
        return false;
    if (p == 2)
        return true;
    auto mp = (BigInt(1) << p) - 1;
    auto s  = BigInt(4);
    foreach (_; 3 .. p + 1)
        s = (s ^^ 2 - 2) % mp;
    return s == 0;
}

void main() {
    foreach (p; 2 .. 2_300)
        if (isMersennePrime(p)) {
            write(" M", p);
            stdout.flush();
        }
}
