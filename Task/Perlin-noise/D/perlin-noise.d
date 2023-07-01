import std.stdio, std.math;

struct PerlinNoise {
    private static double fade(in double t) pure nothrow @safe @nogc {
        return t ^^ 3 * (t * (t * 6 - 15) + 10);
    }

    private static double lerp(in double t, in double a, in double b)
    pure nothrow @safe @nogc {
        return a + t * (b - a);
    }

    private static double grad(in ubyte hash,
                               in double x, in double y, in double z)
    pure nothrow @safe @nogc {
        // Convert lo 4 bits of hash code into 12 gradient directions.
        immutable h = hash & 0xF;
        immutable double u = (h < 8) ? x : y,
                         v = (h < 4) ? y : (h == 12 || h == 14 ? x : z);
        return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v);
    }

    static immutable ubyte[512] p;

    static this() pure nothrow @safe @nogc {
        static immutable permutation = cast(ubyte[256])x"97 A0 89 5B 5A
            0F 83 0D C9 5F 60 35 C2 E9 07 E1 8C 24 67 1E 45 8E 08 63 25
            F0 15 0A 17 BE 06 94 F7 78 EA 4B 00 1A C5 3E 5E FC DB CB 75
            23 0B 20 39 B1 21 58 ED 95 38 57 AE 14 7D 88 AB A8 44 AF 4A
            A5 47 86 8B 30 1B A6 4D 92 9E E7 53 6F E5 7A 3C D3 85 E6 DC
            69 5C 29 37 2E F5 28 F4 66 8F 36 41 19 3F A1 01 D8 50 49 D1
            4C 84 BB D0 59 12 A9 C8 C4 87 82 74 BC 9F 56 A4 64 6D C6 AD
            BA 03 40 34 D9 E2 FA 7C 7B 05 CA 26 93 76 7E FF 52 55 D4 CF
            CE 3B E3 2F 10 3A 11 B6 BD 1C 2A DF B7 AA D5 77 F8 98 02 2C
            9A A3 46 DD 99 65 9B A7 2B AC 09 81 16 27 FD 13 62 6C 6E 4F
            71 E0 E8 B2 B9 70 68 DA F6 61 E4 FB 22 F2 C1 EE D2 90 0C BF
            B3 A2 F1 51 33 91 EB F9 0E EF 6B 31 C0 D6 1F B5 C7 6A 9D B8
            54 CC B0 73 79 32 2D 7F 04 96 FE 8A EC CD 5D DE 72 43 1D 18
            48 F3 8D 80 C3 4E 42 D7 3D 9C B4";

        // Two copies of permutation.
        p[0 .. permutation.length] = permutation[];
        p[permutation.length .. $] = permutation[];
    }

    /// x0, y0 and z0 can be any real numbers, but the result is
    /// zero if they are all integers.
    /// The result is probably in [-1.0, 1.0].
    static double opCall(in double x0, in double y0, in double z0)
    pure nothrow @safe @nogc {
        // Find unit cube that contains point.
        immutable ubyte X = cast(int)x0.floor & 0xFF,
                        Y = cast(int)y0.floor & 0xFF,
                        Z = cast(int)z0.floor & 0xFF;

        // Find relative x,y,z of point in cube.
        immutable x = x0 - x0.floor,
                  y = y0 - y0.floor,
                  z = z0 - z0.floor;

        // Compute fade curves for each of x,y,z.
        immutable u = fade(x),
                  v = fade(y),
                  w = fade(z);

        // Hash coordinates of the 8 cube corners.
        immutable A  = p[X  ]   + Y,
                  AA = p[A]     + Z,
                  AB = p[A + 1] + Z,
                  B  = p[X + 1] + Y,
                  BA = p[B]     + Z,
                  BB = p[B + 1] + Z;

        // And add blended results from  8 corners of cube.
        return lerp(w, lerp(v, lerp(u, grad(p[AA  ], x  , y  , z  ),
                                       grad(p[BA  ], x-1, y  , z  )),
                               lerp(u, grad(p[AB  ], x  , y-1, z  ),
                                       grad(p[BB  ], x-1, y-1, z  ))),
                       lerp(v, lerp(u, grad(p[AA+1], x  , y  , z-1),
                                       grad(p[BA+1], x-1, y  , z-1)),
                               lerp(u, grad(p[AB+1], x  , y-1, z-1),
                                       grad(p[BB+1], x-1, y-1, z-1))));
    }
}

void main() {
    writefln("%1.17f", PerlinNoise(3.14, 42, 7));

    /*
    // Generate a demo image using the Gray Scale task module.
    import grayscale_image;
    enum N = 200;
    auto im = new Image!Gray(N, N);
    foreach (immutable y; 0 .. N)
        foreach (immutable x; 0 .. N) {
            immutable p = PerlinNoise(x / 30.0, y / 30.0, 0.1);
            im[x, y] = Gray(cast(ubyte)((p + 1) / 2 * 256));
        }
    im.savePGM("perlin_noise.pgm");
    */
}
