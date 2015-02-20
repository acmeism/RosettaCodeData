import std.stdio, std.string, std.range;

ubyte[16] md4(const(ubyte)[] inData) pure nothrow {
    enum f = (uint x, uint y, uint z) => (x & y) | (~x & z);
    enum g = (uint x, uint y, uint z) => (x & y) | (x & z) | (y & z);
    enum h = (uint x, uint y, uint z) => x ^ y ^ z;
    enum r = (uint v, uint s) => (v << s) | (v >> (32 - s));

    immutable bitLen = ulong(inData.length) << 3;
    inData ~= 0x80;
    while (inData.length % 64 != 56)
        inData ~= 0;
    const data = cast(uint[])inData ~ [uint(bitLen & uint.max), uint(bitLen >> 32)];

    uint a = 0x67452301, b = 0xefcdab89, c = 0x98badcfe, d = 0x10325476;

    foreach (const x; data.chunks(16)) {
        immutable a2 = a, b2 = b, c2 = c, d2 = d;
        foreach (immutable i; [0, 4, 8, 12]) {
            a = r(a + f(b, c, d) + x[i+0],  3);
            d = r(d + f(a, b, c) + x[i+1],  7);
            c = r(c + f(d, a, b) + x[i+2], 11);
            b = r(b + f(c, d, a) + x[i+3], 19);
        }
        foreach (immutable i; [0, 1, 2, 3]) {
            a = r(a + g(b, c, d) + x[i+0] + 0x5a827999,  3);
            d = r(d + g(a, b, c) + x[i+4] + 0x5a827999,  5);
            c = r(c + g(d, a, b) + x[i+8] + 0x5a827999,  9);
            b = r(b + g(c, d, a) + x[i+12] + 0x5a827999, 13);
        }
        foreach (immutable i; [0, 2, 1, 3]) {
            a = r(a + h(b, c, d) + x[i+0] + 0x6ed9eba1,  3);
            d = r(d + h(a, b, c) + x[i+8] + 0x6ed9eba1,  9);
            c = r(c + h(d, a, b) + x[i+4] + 0x6ed9eba1, 11);
            b = r(b + h(c, d, a) + x[i+12] + 0x6ed9eba1, 15);
        }
        a += a2, b += b2, c += c2, d += d2;
    }

    //return cast(ubyte[16])[a, b, c, d];
    immutable uint[4] result = [a, b, c, d];
    return cast(ubyte[16])result;
}

void main() {
    writefln("%(%02x%)", "Rosetta Code".representation.md4);
}
