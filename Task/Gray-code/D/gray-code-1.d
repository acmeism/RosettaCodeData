uint grayEncode(in uint n) pure nothrow @nogc {
    return n ^ (n >> 1);
}

uint grayDecode(uint n) pure nothrow @nogc {
    auto p = n;
    while (n >>= 1)
        p ^= n;
    return p;
}

void main() {
    import std.stdio;

    " N     N2      enc     dec2 dec".writeln;
    foreach (immutable n; 0 .. 32) {
        immutable g = n.grayEncode;
        immutable d = g.grayDecode;
        writefln("%2d: %5b => %5b => %5b: %2d", n, n, g, d, d);
        assert(d == n);
    }
}
