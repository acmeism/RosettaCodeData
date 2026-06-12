import grayscale_image;

/// Currently this accepts only a Grayscale image, for simplicity.
Image!Gray rescaleGray(in Image!Gray src, in float scaleX, in float scaleY)
pure nothrow @safe
in {
    assert(src !is null, "Input Image is null.");
    assert(src.nx > 1 && src.ny > 1, "Minimal input image size is 2x2.");
    assert(cast(uint)(src.nx * scaleX) > 0, "Output image width must be > 0.");
    assert(cast(uint)(src.ny * scaleY) > 0, "Output image height must be > 0.");
} body {
    alias FP = float;
    static FP lerp(in FP s, in FP e, in FP t) pure nothrow @safe @nogc {
        return s + (e - s) * t;
    }

    static FP blerp(in FP c00, in FP c10, in FP c01, in FP c11,
                    in FP tx, in FP ty) pure nothrow @safe @nogc {
        return lerp(lerp(c00, c10, tx), lerp(c01, c11, tx), ty);
    }

    immutable newWidth = cast(uint)(src.nx * scaleX);
    immutable newHeight = cast(uint)(src.ny * scaleY);
    auto result = new Image!Gray(newWidth, newHeight, true);

    foreach (immutable y; 0 .. newHeight)
        foreach (immutable x; 0 .. newWidth) {
            immutable FP gx = x / FP(newWidth) * (src.nx - 1);
            immutable FP gy = y / FP(newHeight) * (src.ny - 1);
            immutable gxi = cast(uint)gx;
            immutable gyi = cast(uint)gy;

            immutable c00 = src[gxi,     gyi    ];
            immutable c10 = src[gxi + 1, gyi    ];
            immutable c01 = src[gxi,     gyi + 1];
            immutable c11 = src[gxi + 1, gyi + 1];

            immutable pixel = blerp(c00, c10, c01, c11, gx - gxi, gy - gyi);
            result[x, y] = Gray(cast(ubyte)pixel);
        }

    return result;
}

void main() {
    const im = loadPGM!Gray(null, "lena.pgm");
    im.rescaleGray(0.3, 0.1).savePGM("lena_smaller.pgm");
    im.rescaleGray(1.3, 1.8).savePGM("lena_larger.pgm");
}
