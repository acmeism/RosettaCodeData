import std.stdio, std.bigint, std.range, std.algorithm;

auto binomialCoeff(in uint n, in uint k) pure nothrow {
    BigInt result = 1;
    foreach (immutable i; 1 .. k + 1)
        result = result * (n - i + 1) / i;
    return result;
}

auto pascalUpp(in uint n) pure nothrow {
    return n.iota.map!(i => n.iota.map!(j => binomialCoeff(j, i)));
}

auto pascalLow(in uint n) pure nothrow {
    return n.iota.map!(i => n.iota.map!(j => binomialCoeff(i, j)));
}

auto pascalSym(in uint n) pure nothrow {
    return n.iota.map!(i => n.iota.map!(j => binomialCoeff(i + j, i)));
}

void main() {
    enum n = 5;
    writefln("Upper:\n%(%(%2d %)\n%)", pascalUpp(n));
    writefln("\nLower:\n%(%(%2d %)\n%)", pascalLow(n));
    writefln("\nSymmetric:\n%(%(%2d %)\n%)", pascalSym(n));
}
