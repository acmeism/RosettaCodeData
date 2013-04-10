import core.stdc.stdio, std.stdio, std.ascii, std.algorithm, std.math,
       std.typecons, std.range, std.conv, std.string, bitmap;

struct Col { float r, g, b; }
alias Tuple!(Col, float, Col, Col[]) Cluster;
enum Axis { R, G, B }

int round(in float x) /*pure*/ nothrow {
    return cast(int)floor(x + 0.5); // Not pure.
}

RGB roundRGB(in Col c) /*pure*/ nothrow {
    return RGB(cast(ubyte)round(c.r), // Not pure.
               cast(ubyte)round(c.g),
               cast(ubyte)round(c.b));
}

Col meanRGB(Col[] pxList) pure nothrow {
    static Col addRGB(in Col c1, in Col c2) pure nothrow {
        return Col(c1.r + c2.r, c1.g + c2.g, c1.b + c2.b);
    }
    immutable Col tot = reduce!addRGB(Col(0,0,0), pxList);
    immutable int n = pxList.walkLength();
    return Col(tot.r / n, tot.g / n, tot.b / n);
}

Tuple!(Col, Col) extrems(/*in*/ Col[] lst) pure nothrow {
    immutable minRGB = Col(float.infinity,
                           float.infinity,
                           float.infinity);
    immutable maxRGB = Col(-float.infinity,
                           -float.infinity,
                           -float.infinity);
    static Col f1(in Col c1, in Col c2) pure nothrow {
        return Col(min(c1.r, c2.r), min(c1.g, c2.g), min(c1.b, c2.b));
    }
    static Col f2(in Col c1, in Col c2) pure nothrow {
        return Col(max(c1.r, c2.r), max(c1.g, c2.g), max(c1.b, c2.b));
    }
    return typeof(return)(reduce!f1(minRGB, lst),
                          reduce!f2(maxRGB, lst));
}

Tuple!(float, Col) volumeAndDims(/*in*/ Col[] lst) pure nothrow {
    immutable e = extrems(lst);
    immutable Col r = Col(e[1].r - e[0].r,
                          e[1].g - e[0].g,
                          e[1].b - e[0].b);
    return typeof(return)(r.r * r.g * r.b, r);
}

Cluster makeCluster(Col[] pixel_list) pure nothrow {
    immutable vol_dims = volumeAndDims(pixel_list);
    immutable int len = pixel_list.length;
    return Cluster(meanRGB(pixel_list),
                   len * vol_dims[0],
                   vol_dims[1],
                   pixel_list);
}

Axis largestAxis(in Col c) pure nothrow {
    static int fcmp(in float a, in float b) pure nothrow {
        return (a > b) ? 1 : (a < b ? -1 : 0);
    }
    immutable int r1 = fcmp(c.r, c.g);
    immutable int r2 = fcmp(c.r, c.b);
    if (r1 == 1 && r2 == 1) return Axis.R;
    if (r1 == -1 && r2 == 1) return Axis.G;
    if (r1 == 1 && r2 == -1) return Axis.B;
    return (fcmp(c.g, c.b) == 1) ? Axis.G : Axis.B;
}

Tuple!(Cluster, Cluster) subdivide(in Col c, in float nVolProd,
                                   in Col vol, Col[] pixels)
/*pure*/ nothrow {
    bool delegate(immutable Col c) /*pure*/ nothrow partFunc;
    final switch (largestAxis(vol)) {
        case Axis.R: partFunc = c1 => c1.r < c.r; break;
        case Axis.G: partFunc = c1 => c1.g < c.g; break;
        case Axis.B: partFunc = c1 => c1.b < c.b; break;
    }
    Col[] px2 = pixels.partition!partFunc; // Not pure.
    Col[] px1 = pixels[0 .. $ - px2.length];
    return typeof(return)(makeCluster(px1), makeCluster(px2));
}

Image!RGB colorQuantize(in Image!RGB img, in int n)
/*pure*/ nothrow {
    immutable int width = img.nx;
    immutable int height = img.ny;

    auto cols = new Col[width * height];
    foreach (immutable i, ref c; img.image)
        cols[i] = Col(c.r, c.g, c.b);
    Cluster[] clusters = [makeCluster(cols)];

    immutable Col dumb = Col(0.0, 0.0, 0.0);
    Cluster unused = Cluster(dumb,
                             -float.infinity,
                             dumb, (Col[]).init);

    while (clusters.length < n) {
        Cluster cl = reduce!((c1,c2) => c1[1] > c2[1] ? c1 : c2)
                            (unused, clusters);
        clusters = [subdivide(cl.tupleof).tupleof] ~
            remove!(c => c == cl, SwapStrategy.unstable)(clusters);
    }

    static uint RGB2uint(in RGB c) pure nothrow {
        uint r;
        r |= c.r;
        r |= c.g << 8;
        r |= c.b << 16;
        return r;
    }

    uint[uint] pixMap; // faster than RGB[RGB]
    ubyte[4] u4a, u4b;
    foreach (const cluster; clusters) {
        immutable ubyteMean = RGB2uint(roundRGB(cluster[0]));
        foreach (immutable col; cluster[3])
            pixMap[RGB2uint(roundRGB(col))] = ubyteMean;
    }

    auto result = new Image!RGB;
    result.allocate(height, width);

    static RGB uintToRGB(in uint c) pure nothrow {
        return RGB( c        & 0xFF,
                   (c >>  8) & 0xFF,
                   (c >> 16) & 0xFF);
    }

    foreach (immutable i; 0 .. height * width) {
        immutable u3a = RGB(img.image[i].r,
                            img.image[i].g,
                            img.image[i].b);
        result.image[i] = uintToRGB(pixMap[RGB2uint(u3a)]);
    }

    return result;
}

void main(in string[] args) {
    string fileName;
    int nCols;
    switch (args.length) {
        case 1:
            fileName = "quantum_frog.ppm";
            nCols = 16;
            break;
        case 3:
            fileName = args[1];
            nCols = to!int(args[2]);
            break;
        default:
            writeln("Usage: color_quantization image.ppm ncolors");
            return;
    }

    auto im = new Image!RGB;
    im.loadPPM6(fileName);
    const imq = colorQuantize(im, nCols);
    imq.savePPM6("quantum_frog_quantized.ppm");
}
