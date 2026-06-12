import std.algorithm: min;
import std.algorithm: copy;
import std.typetuple: TypeTuple;
import std.typecons: staticIota;

struct ISAAC {
    // External results.
    private uint[mm.length] randResult;
    private uint randCount;

    // Internal state.
    private uint[256] mm;
    private uint aa, bb, cc;


    private void isaac() pure nothrow @safe @nogc {
        cc++;         // cc just gets incremented once per mm.length results.
        bb = bb + cc; // Then combined with bb.

        foreach (immutable i, ref mmi; mm) {
            immutable x = mm[i];
            final switch (i % 4) { // Not enforced final switch.
                case 0: aa ^= (aa << 13); break;
                case 1: aa ^= (aa >>  6); break;
                case 2: aa ^= (aa <<  2); break;
                case 3: aa ^= (aa >> 16); break;
            }

            aa = mm[(i + 128) % $] + aa;
            immutable y = mm[(x >> 2) % $] + aa + bb;
            bb = mm[(y >> 10) % $] + x;
            randResult[i] = bb;
        }

        randCount = 0;
    }


    // If flag is true then use the contents of randResult to initialize mm.
    private pure nothrow @safe @nogc static void mix(ref uint[8] a)  {
        alias shifts = TypeTuple!(11, 2, 8, 16, 10, 4, 8, 9);
        /*static*/ foreach (immutable i, immutable sh; shifts) {
            static if (i % 2 == 0)
                a[i] ^= a[(i + 1) % $] << sh;
            else
                a[i] ^= a[(i + 1) % $] >> sh;
            a[(i + 3) % $] += a[i];
            a[(i + 1) % $] += a[(i + 2) % $];
        }
    }


    private void randInit(bool flag)() pure nothrow @safe @nogc {
        uint[8] a = 0x9E37_79B9; // The Golden Ratio.
        aa = bb = cc = 0;

        // Scramble it.
        /*static*/ foreach (immutable i; staticIota!(0, 4))
            mix(a);

        // Fill in mm with messy stuff. Use all the information in the seed.
        for (size_t i = 0; i < mm.length; i += 8) {
            static if (flag)
                a[] += randResult[i .. i + 8];
            mix(a);
            mm[i .. i + 8] = a[];
        }

        // Do a second pass to make all of the seed affect all of mm.
        static if (flag) {
            for (size_t i = 0; i < mm.length; i += 8) {
                a[] += mm[i .. i + 8];
                mix(a);
                mm[i .. i + 8] = a[];
            }
        }

        isaac();       // Fill in the first set of results.
        randCount = 0; // Prepare to use the first set of results.
    }


    /// Seed ISAAC with a string.
    /// Uses only the first randResult.length ubytes.
    public void iSeed(bool flag)(in ubyte[] seed) pure nothrow @safe @nogc {
        mm[] = 0;
        randResult[] = 0;

        immutable n = min(randResult.length, seed.length);
        copy(seed[0 .. n], randResult[0 .. n]);

        randInit!flag(); // Initialize ISAAC with seed.
    }


    /// Get a random uint.
    private uint iRandom() pure nothrow @safe @nogc {
        immutable result = randResult[randCount];

        randCount++;
        if (randCount > (randResult.length - 1)) {
            isaac();
            randCount = 0;
        }

        return result;
    }


    /// Get a random character in printable ASCII range.
    private ubyte iRandA() pure nothrow @safe @nogc {
        return iRandom() % 95 + 32;
    }


    /// XOR encrypt on random stream.
    /// buffer must be as large as message or larger.
    public ubyte[] vernam(in ubyte[] message, ubyte[] buffer)
    pure nothrow @safe @nogc
    in {
        assert(buffer.length >= message.length);
    } out(result) {
        assert(result.length == message.length);
    } body {
        auto v = buffer[0 .. message.length];

        // XOR message.
        foreach (immutable i, immutable msgi; message)
            v[i] = (iRandA() ^ msgi);
        return v;
    }


    /// XOR encrypt on random stream.
    public ubyte[] vernam(in ubyte[] message) pure nothrow @safe {
        return vernam(message, new ubyte[message.length]);
    }
}


void main() {
    import std.stdio, std.string;

    immutable message = "a Top Secret secret";
    immutable key = "this is my secret key";

    writeln("Message  : ", message);
    writeln("Key      : ", key);

    ISAAC cipher;

    // Encrypt.
    // iSeed uses only the first ISAAC.randResult.length ubytes.
    cipher.iSeed!true(key.representation);
    const encrypted = cipher.vernam(message.representation);

    // Output ciphertext as a string of hexadecimal digits.
    writefln("Encrypted: %(%02X%)", encrypted);

    // Decrypt.
    cipher.iSeed!true(key.representation);
    const decrypted = cipher.vernam(encrypted);

    writeln("Decrypted: ", decrypted.assumeUTF);
}
