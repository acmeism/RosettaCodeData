// Copyright (C) 2005, 2006 Free Software Foundation, Inc. GNU License.
// Translated to D language. Only lightly tested, not for serious use.

import core.stdc.string: memcpy;
import core.bitop: bswap;

struct SHA256 {
    enum uint BLOCK_SIZE = 4096;
    static assert(BLOCK_SIZE % 64 == 0, "Invalid BLOCK_SIZE.");

    uint[8] state;
    uint[2] total;
    uint bufLen;
    union {
        uint[32] buffer;
        ubyte[buffer.sizeof] bufferB;
    }

    alias TResult = ubyte[256 / 8];

    version(WORDS_BIGENDIAN) {
        static uint bswap(in uint n) pure nothrow @safe @nogc { return n; }
    }

    // Bytes used to pad the buffer to the next 64-byte boundary.
    static immutable ubyte[64] fillBuf = [0x80, 0 /* , 0, 0, ...  */];


    /** Initialize structure containing state of computation.
    Takes a pointer to a 256 bit block of data (eight 32 bit ints) and
    intializes it to the start constants of the SHA256 algorithm. This
    must be called before using hash in the call to sha256_hash. */
    void init() pure nothrow @safe @nogc {
        state = [0x6a09e667U, 0xbb67ae85U, 0x3c6ef372U, 0xa54ff53aU,
                 0x510e527fU, 0x9b05688cU, 0x1f83d9abU, 0x5be0cd19U];
        total[] = 0;
        bufLen = 0;
    }


    /** Starting with the result of former calls of this function (or
    the initialization function) update the context for the next LEN
    bytes starting at BUFFER.
    It is not required that LEN is a multiple of 64. */
    void processBytes(in ubyte[] inBuffer) pure nothrow @nogc {
        // When we already have some bits in our internal
        // buffer concatenate both inputs first.
        const(ubyte)* inBufferPtr = inBuffer.ptr;
        auto len = inBuffer.length;

        if (bufLen != 0) {
            immutable size_t left_over = bufLen;
            immutable size_t add = (128 - left_over > len) ?
                                   len :
                                   128 - left_over;

            memcpy(&bufferB[left_over], inBufferPtr, add);
            bufLen += add;

            if (bufLen > 64) {
                processBlock(bufferB[0 .. bufLen & ~63]);

                bufLen &= 63;
                // The regions in the following copy operation cannot overlap.
                memcpy(bufferB.ptr, &bufferB[(left_over + add) & ~63], bufLen);
            }

            inBufferPtr += add;
            len -= add;
        }

        // Process available complete blocks.
        if (len >= 64) {
            processBlock(inBufferPtr[0 .. len & ~63]);
            inBufferPtr += (len & ~63);
            len &= 63;
        }

        // Move remaining bytes in internal buffer.
        if (len > 0) {
            size_t left_over = bufLen;

            memcpy(&bufferB[left_over], inBufferPtr, len);
            left_over += len;
            if (left_over >= 64) {
                processBlock(bufferB[0 .. 64]);
                left_over -= 64;
                memcpy(bufferB.ptr, &bufferB[64], left_over);
            }
            bufLen = left_over;
        }
    }


    /** Starting with the result of former calls of this function
    (or the initialization function) update the context ctx for
    the next len bytes starting at buffer.
    It is necessary that len is a multiple of 64. */
    void processBlock(in ubyte[] inBuffer)
    pure nothrow @nogc in {
        assert(inBuffer.length % 64 == 0);
    } do {
        // Round functions.
        static uint F1(in uint e, in uint f, in uint g) pure nothrow @safe @nogc {
            return g ^ (e & (f ^ g));
        }

        static uint F2(in uint a, in uint b, in uint c) pure nothrow @safe @nogc {
            return (a & b) | (c & (a | b));
        }

        immutable len = inBuffer.length;
        auto words = cast(uint*)inBuffer.ptr;
        immutable size_t nWords = len / uint.sizeof;
        const uint* endp = words + nWords;
        uint[16] x = void;
        auto a = state[0];
        auto b = state[1];
        auto c = state[2];
        auto d = state[3];
        auto e = state[4];
        auto f = state[5];
        auto g = state[6];
        auto h = state[7];

        // First increment the byte count. FIPS PUB 180-2 specifies the
        // possible length of the file up to 2^64 bits. Here we only
        // compute the number of bytes.  Do a double word increment.
        total[0] += len;
        if (total[0] < len)
            total[1]++;

        static uint rol(in uint x, in uint n) pure nothrow @safe @nogc {
            return (x << n) | (x >> (32 - n)); }
        static uint S0(in uint x) pure nothrow @safe @nogc {
            return rol(x, 25) ^ rol(x, 14) ^ (x >> 3); }
        static uint S1(in uint x) pure nothrow @safe @nogc {
            return rol(x, 15) ^ rol(x, 13) ^ (x >> 10); }
        static uint SS0(in uint x) pure nothrow @safe @nogc {
            return rol(x, 30) ^ rol(x,19) ^ rol(x, 10); }
        static uint SS1(in uint x) pure nothrow @safe @nogc {
            return rol(x, 26) ^ rol(x, 21) ^ rol(x, 7); }

        uint M(in uint I) pure nothrow @safe @nogc {
            immutable uint tm = S1(x[(I - 2) & 0x0f]) +
                                x[(I - 7) & 0x0f] +
                                S0(x[(I - 15) & 0x0f]) +
                                x[I & 0x0f];
            x[I & 0x0f] = tm;
            return tm;
        }

        static void R(in uint a, in uint b, in uint c, ref uint d,
                      in uint e, in uint f, in uint g, ref uint h,
                      in uint k, in uint m) pure nothrow @safe @nogc {
            immutable t0 = SS0(a) + F2(a, b, c);
            immutable t1 = h + SS1(e) + F1(e, f, g) + k + m;
            d += t1;
            h = t0 + t1;
        }

        // SHA256 round constants.
        static immutable uint[64] K = [
            0x428a2f98U, 0x71374491U, 0xb5c0fbcfU, 0xe9b5dba5U,
            0x3956c25bU, 0x59f111f1U, 0x923f82a4U, 0xab1c5ed5U,
            0xd807aa98U, 0x12835b01U, 0x243185beU, 0x550c7dc3U,
            0x72be5d74U, 0x80deb1feU, 0x9bdc06a7U, 0xc19bf174U,
            0xe49b69c1U, 0xefbe4786U, 0x0fc19dc6U, 0x240ca1ccU,
            0x2de92c6fU, 0x4a7484aaU, 0x5cb0a9dcU, 0x76f988daU,
            0x983e5152U, 0xa831c66dU, 0xb00327c8U, 0xbf597fc7U,
            0xc6e00bf3U, 0xd5a79147U, 0x06ca6351U, 0x14292967U,
            0x27b70a85U, 0x2e1b2138U, 0x4d2c6dfcU, 0x53380d13U,
            0x650a7354U, 0x766a0abbU, 0x81c2c92eU, 0x92722c85U,
            0xa2bfe8a1U, 0xa81a664bU, 0xc24b8b70U, 0xc76c51a3U,
            0xd192e819U, 0xd6990624U, 0xf40e3585U, 0x106aa070U,
            0x19a4c116U, 0x1e376c08U, 0x2748774cU, 0x34b0bcb5U,
            0x391c0cb3U, 0x4ed8aa4aU, 0x5b9cca4fU, 0x682e6ff3U,
            0x748f82eeU, 0x78a5636fU, 0x84c87814U, 0x8cc70208U,
            0x90befffaU, 0xa4506cebU, 0xbef9a3f7U, 0xc67178f2U];

        while (words < endp) {
            foreach (ref xi; x) {
                xi = bswap(*words);
                words++;
            }

            R(a, b, c, d, e, f, g, h, K[ 0], x[ 0]);
            R(h, a, b, c, d, e, f, g, K[ 1], x[ 1]);
            R(g, h, a, b, c, d, e, f, K[ 2], x[ 2]);
            R(f, g, h, a, b, c, d, e, K[ 3], x[ 3]);
            R(e, f, g, h, a, b, c, d, K[ 4], x[ 4]);
            R(d, e, f, g, h, a, b, c, K[ 5], x[ 5]);
            R(c, d, e, f, g, h, a, b, K[ 6], x[ 6]);
            R(b, c, d, e, f, g, h, a, K[ 7], x[ 7]);
            R(a, b, c, d, e, f, g, h, K[ 8], x[ 8]);
            R(h, a, b, c, d, e, f, g, K[ 9], x[ 9]);
            R(g, h, a, b, c, d, e, f, K[10], x[10]);
            R(f, g, h, a, b, c, d, e, K[11], x[11]);
            R(e, f, g, h, a, b, c, d, K[12], x[12]);
            R(d, e, f, g, h, a, b, c, K[13], x[13]);
            R(c, d, e, f, g, h, a, b, K[14], x[14]);
            R(b, c, d, e, f, g, h, a, K[15], x[15]);
            R(a, b, c, d, e, f, g, h, K[16], M(16));
            R(h, a, b, c, d, e, f, g, K[17], M(17));
            R(g, h, a, b, c, d, e, f, K[18], M(18));
            R(f, g, h, a, b, c, d, e, K[19], M(19));
            R(e, f, g, h, a, b, c, d, K[20], M(20));
            R(d, e, f, g, h, a, b, c, K[21], M(21));
            R(c, d, e, f, g, h, a, b, K[22], M(22));
            R(b, c, d, e, f, g, h, a, K[23], M(23));
            R(a, b, c, d, e, f, g, h, K[24], M(24));
            R(h, a, b, c, d, e, f, g, K[25], M(25));
            R(g, h, a, b, c, d, e, f, K[26], M(26));
            R(f, g, h, a, b, c, d, e, K[27], M(27));
            R(e, f, g, h, a, b, c, d, K[28], M(28));
            R(d, e, f, g, h, a, b, c, K[29], M(29));
            R(c, d, e, f, g, h, a, b, K[30], M(30));
            R(b, c, d, e, f, g, h, a, K[31], M(31));
            R(a, b, c, d, e, f, g, h, K[32], M(32));
            R(h, a, b, c, d, e, f, g, K[33], M(33));
            R(g, h, a, b, c, d, e, f, K[34], M(34));
            R(f, g, h, a, b, c, d, e, K[35], M(35));
            R(e, f, g, h, a, b, c, d, K[36], M(36));
            R(d, e, f, g, h, a, b, c, K[37], M(37));
            R(c, d, e, f, g, h, a, b, K[38], M(38));
            R(b, c, d, e, f, g, h, a, K[39], M(39));
            R(a, b, c, d, e, f, g, h, K[40], M(40));
            R(h, a, b, c, d, e, f, g, K[41], M(41));
            R(g, h, a, b, c, d, e, f, K[42], M(42));
            R(f, g, h, a, b, c, d, e, K[43], M(43));
            R(e, f, g, h, a, b, c, d, K[44], M(44));
            R(d, e, f, g, h, a, b, c, K[45], M(45));
            R(c, d, e, f, g, h, a, b, K[46], M(46));
            R(b, c, d, e, f, g, h, a, K[47], M(47));
            R(a, b, c, d, e, f, g, h, K[48], M(48));
            R(h, a, b, c, d, e, f, g, K[49], M(49));
            R(g, h, a, b, c, d, e, f, K[50], M(50));
            R(f, g, h, a, b, c, d, e, K[51], M(51));
            R(e, f, g, h, a, b, c, d, K[52], M(52));
            R(d, e, f, g, h, a, b, c, K[53], M(53));
            R(c, d, e, f, g, h, a, b, K[54], M(54));
            R(b, c, d, e, f, g, h, a, K[55], M(55));
            R(a, b, c, d, e, f, g, h, K[56], M(56));
            R(h, a, b, c, d, e, f, g, K[57], M(57));
            R(g, h, a, b, c, d, e, f, K[58], M(58));
            R(f, g, h, a, b, c, d, e, K[59], M(59));
            R(e, f, g, h, a, b, c, d, K[60], M(60));
            R(d, e, f, g, h, a, b, c, K[61], M(61));
            R(c, d, e, f, g, h, a, b, K[62], M(62));
            R(b, c, d, e, f, g, h, a, K[63], M(63));

            a = state[0] += a;
            b = state[1] += b;
            c = state[2] += c;
            d = state[3] += d;
            e = state[4] += e;
            f = state[5] += f;
            g = state[6] += g;
            h = state[7] += h;
        }
    }


    /** Process the remaining bytes in the internal buffer and the
    usual prolog according to the standard and write the result to
    resBuf.
    Important: On some systems it is required that resBuf is correctly
    aligned for a 32-bit value. */
    void conclude() pure nothrow @nogc {
        // Take yet unprocessed bytes into account.
        immutable bytes = bufLen;
        immutable size_t size = (bytes < 56) ? 64 / 4 : 64 * 2 / 4;

        // Now count remaining bytes.
        total[0] += bytes;
        if (total[0] < bytes)
            total[1]++;

        // Put the 64-bit file length in *bits* at the end of
        // the buffer.
        buffer[size - 2] = bswap((total[1] << 3) | (total[0] >> 29));
        buffer[size - 1] = bswap(total[0] << 3);

        memcpy(&bufferB[bytes], fillBuf.ptr, (size - 2) * 4 - bytes);

        // Process last bytes.
        processBlock(bufferB[0 .. size * 4]);
    }


    /** Put result from this in first 32 bytes following resBuf. The
    result must be in little endian byte order.
    Important: On some systems it is required that resBuf is correctly
    aligned for a 32-bit value. */
    ref TResult read(return ref TResult resBuf) pure nothrow @nogc {
        foreach (immutable i, immutable s; state)
            (cast(uint*)resBuf.ptr)[i] = bswap(s);
        return resBuf;
    }


    /** Process the remaining bytes in the buffer and put result from
    CTX in first 32 (28) bytes following resBuf.  The result is always
    in little endian byte order, so that a byte-wise output yields to
    the wanted ASCII representation of the message digest.
    Important: On some systems it is required that resBuf be correctly
    aligned for a 32 bits value. */
    ref TResult finish(return ref TResult resBuf) pure nothrow @nogc {
        conclude;
        return read(resBuf);
    }


    /** Compute SHA512 message digest for LEN bytes beginning at
    buffer. The result is always in little endian byte order, so that
    a byte-wise output yields to the wanted ASCII representation of
    the message digest. */
    static ref TResult digest(in ubyte[] inBuffer, return ref TResult resBuf)
    pure nothrow @nogc {
        SHA256 sha = void;

        // Initialize the computation context.
        sha.init;

        // Process whole buffer but last len % 64 bytes.
        sha.processBytes(inBuffer);

        // Put result in desired memory area.
        return sha.finish(resBuf);
    }


    /// ditto
    static TResult digest(in ubyte[] inBuffer) pure nothrow @nogc {
        align(4) TResult resBuf = void;
        return digest(inBuffer, resBuf);
    }
}


version (sha_256_main) {
    void main() {
        import std.stdio, std.string;

        immutable data = "Rosetta code".representation;
        writefln("%(%02x%)", SHA256.digest(data));
    }
}
