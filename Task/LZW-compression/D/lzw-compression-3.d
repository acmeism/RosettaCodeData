enum Marker: ushort {
    CLR = 256, // Clear table marker.
    EOD = 257, // End-of-data marker.
    NEW = 258  // New code index.
}


ubyte[] lzwEncode(scope const(ubyte)[] inp, in uint maxBits) pure nothrow
in {
    assert(maxBits >= 9 && maxBits <= 16);
} body {
    // Encode dictionary array. For encoding, entry at
    // code index is a list of indices that follow current one,
    // i.e. if code 97 is 'a', code 387 is 'ab', and code 1022 is 'abc',
    // then dict[97].next['b'] = 387, dict[387].next['c'] = 1022, etc.
    alias LZWenc = ushort[256];

    auto len = inp.length;
    uint bits = 9;
    auto d = new LZWenc[512];

    auto result = new ubyte[16];
    size_t outLen = 0;
    size_t oBits = 0;
    uint tmp = 0;

    void writeBits(in ushort x) nothrow {
        tmp = (tmp << bits) | x;
        oBits += bits;
        if (result.length / 2 <= outLen)
            result.length *= 2;
        while (oBits >= 8) {
            oBits -= 8;
            assert(tmp >> oBits <= ubyte.max);
            result[outLen] = cast(ubyte)(tmp >> oBits);
            outLen++;
            tmp &= (1 << oBits) - 1;
        }
    }

    // writeBits(Marker.CLR);
    ushort nextCode = Marker.NEW;
    uint nextShift = 512;
    ushort code = inp[0];
    inp = inp[1 .. $]; // popFront.
    while (--len) {
        ushort c = inp[0];
        inp = inp[1 .. $]; // popFront.
        ushort nc = d[code][c];
        if (nc) {
            code = nc;
        } else {
            writeBits(code);
            nc = d[code][c] = nextCode;
            nextCode++;
            code = c;
        }

        // Next new code would be too long for current table.
        if (nextCode == nextShift) {
            // Either reset table back to 9 bits.
            bits++;
            if (bits > maxBits) {
                // Table clear marker must occur before bit reset.
                writeBits(Marker.CLR);

                bits = 9;
                nextShift = 512;
                nextCode = Marker.NEW;
                d[] = LZWenc.init;
            } else { // Or extend table.
                nextShift *= 2;
                d.length = nextShift;
            }
        }
    }

    writeBits(code);
    writeBits(Marker.EOD);
    if (tmp) {
        assert(tmp <= ushort.max);
        writeBits(cast(ushort)tmp);
    }

    return result[0 .. outLen];
}


ubyte[] lzwDecode(scope const(ubyte)[] inp) pure {
    // For decoding, dictionary contains index of whatever prefix
    // index plus trailing ubyte.  i.e. like previous example,
    //     dict[1022] = { c: 'c', prev: 387 },
    //     dict[387]  = { c: 'b', prev: 97 },
    //     dict[97]   = { c: 'a', prev: 0 }
    // the "back" element is used for temporarily chaining indices
    // when resolving a code to bytes.
    static struct LZWdec {
        ushort prev, back;
        ubyte c;
    }

    auto result = new ubyte[4];
    uint outLen = 0;

    void writeOut(in ubyte c) nothrow {
        while (outLen >= result.length)
            result.length *= 2;
        result[outLen] = c;
        outLen++;
    }

    auto d = new LZWdec[512];
    ushort code = 0;
    uint bits = 9;
    uint len = 0;
    uint nBits = 0;
    uint tmp = 0;

    void getCode() nothrow {
        while (nBits < bits) {
            if (len > 0) {
                len--;
                tmp = (tmp << 8) | inp[0];
                inp = inp[1 .. $]; // popFront.
                nBits += 8;
            } else {
                tmp = tmp << (bits - nBits);
                nBits = bits;
            }
        }

        nBits -= bits;
        assert(tmp >> nBits <= ushort.max);
        code = cast(ushort)(tmp >> nBits);
        tmp &= (1 << nBits) - 1;
    }

    uint nextShift = 512;
    ushort nextCode = Marker.NEW;

    void clearTable() nothrow {
        d[] = LZWdec.init;
        foreach (immutable ubyte j; 0 .. 256)
            d[j].c = j;
        nextCode = Marker.NEW;
        nextShift = 512;
        bits = 9;
    }

    clearTable(); // In case encoded bits didn't start with Marker.CLR.
    for (len = inp.length; len;) {
        getCode();
        if (code == Marker.EOD)
            break;
        if (code == Marker.CLR) {
            clearTable();
            continue;
        }

        if (code >= nextCode)
            throw new Error("Bad sequence.");

        auto c = code;
        d[nextCode].prev = c;
        while (c > 255) {
            immutable t = d[c].prev;
            d[t].back = c;
            c = t;
        }

        assert(c <= ubyte.max);
        d[nextCode - 1].c = cast(ubyte)c;

        while (d[c].back) {
            writeOut(d[c].c);
            immutable t = d[c].back;
            d[c].back = 0;
            c = t;
        }
        writeOut(d[c].c);

        nextCode++;
        if (nextCode >= nextShift) {
            bits++;
            if (bits > 16) {
                // If input was correct, we'd have hit Marker.CLR before this.
                throw new Error("Too many bits.");
            }
            nextShift *= 2;
            d.length = nextShift;
        }
    }

    // Might be OK, so throw just an exception.
    if (code != Marker.EOD)
        throw new Exception("Bits did not end in EOD");

    return result[0 .. outLen];
}


void main() {
    import std.stdio, std.file;

    const inputData = cast(ubyte[])read("unixdict.txt");
    writeln("Input size:   ", inputData.length);

    immutable encoded = lzwEncode(inputData, 12);
    writeln("Encoded size: ", encoded.length);

    immutable decoded = lzwDecode(encoded);
    writeln("Decoded size: ", decoded.length);

    if (inputData.length != decoded.length)
        return writeln("Error: decoded size differs");

    foreach (immutable i, immutable x; inputData)
        if (x != decoded[i])
            return writeln("Bad decode at ", i);

    "Decoded OK.".writeln;
}
