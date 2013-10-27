/// Rotate uint left.
uint rol(in uint x, in uint nBits) @safe pure nothrow {
    return (x << nBits) | (x >> (32 - nBits));
}

alias Nibble = ubyte; // 4 bits used.
alias SBox = immutable Nibble[16][8];

private bool _validateSBox(in SBox data) @safe pure nothrow {
    foreach (ref row; data)
        foreach (ub; row)
            if (ub >= 16) // Verify it's a nibble.
                return false;
    return true;
}

struct GOST(s...) if (s.length == 1 && s[0]._validateSBox) {
    private static generate(ubyte k)() @safe pure nothrow {
        //return iota(k87.length)
        //     .map!(i=> (s[0][k][i >> 4] << 4) | s[0][k - 1][i & 0xF])
        //     .array;
        uint[k87.length] result; // ubytes[...] should suffice.
        foreach (immutable i, ref item; result)
            item = (s[0][k][i >> 4] << 4) | s[0][k - 1][i & 0xF];
        return result;
    }

    private uint[2] buffer;
    private static immutable ubyte[256] k87 = generate!7,
                                        k65 = generate!5,
                                        k43 = generate!3,
                                        k21 = generate!1;

    // Endianess problems?
    private static uint f(in uint x) pure nothrow {
        immutable uint y = (k87[(x >> 24) & 0xFF] << 24) |
                           (k65[(x >> 16) & 0xFF] << 16) |
                           (k43[(x >>  8) & 0xFF] <<  8) |
                            k21[ x        & 0xFF];
        return rol(y, 11);
    }

    // This performs only a step of the encoding.
    public void mainStep(in uint[2] input, in uint key) pure nothrow {
        buffer[0] = f(key + input[0]) ^ input[1];
        buffer[1] = input[0];
    }
}

void main() {
    import std.stdio;

    // S-boxes used by the Central Bank of Russian Federation:
    // http://en.wikipedia.org/wiki/GOST_28147-89
    // (This is a matrix of nibbles).
    enum SBox cbrf = [
      [ 4, 10,  9,  2, 13,  8,  0, 14,  6, 11,  1, 12,  7, 15,  5,  3],
      [14, 11,  4, 12,  6, 13, 15, 10,  2,  3,  8,  1,  0,  7,  5,  9],
      [ 5,  8,  1, 13, 10,  3,  4,  2, 14, 15, 12,  7,  6,  0,  9, 11],
      [ 7, 13, 10,  1,  0,  8,  9, 15, 14,  4,  6, 12, 11,  2,  5,  3],
      [ 6, 12,  7,  1,  5, 15, 13,  8,  4, 10,  9, 14,  0,  3, 11,  2],
      [ 4, 11, 10,  0,  7,  2,  1, 13,  3,  6,  8,  5,  9, 12, 15, 14],
      [13, 11,  4,  1,  3, 15,  5,  9,  0, 10, 14,  7,  6,  8,  2, 12],
      [ 1, 15, 13,  0,  5,  7, 10,  4,  9,  2,  3, 14,  6, 11,  8, 12]];

    GOST!cbrf g;

    // Example from the talk page (bytes swapped for endianess):
    immutable uint[2] input = [0x_04_3B_04_21, 0x_04_32_04_30];
    immutable uint key = 0x_E2_C1_04_F9;

    g.mainStep(input, key);
    writefln("%(%08X %)", g.buffer);
}
