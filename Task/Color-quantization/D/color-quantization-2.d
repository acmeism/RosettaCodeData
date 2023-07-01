import core.stdc.stdlib: malloc, calloc, realloc, free, abort;
import std.stdio: stderr, File;
import std.ascii: isWhite;
import std.math: abs;
import std.conv: to;
import std.string: split, strip;
import std.exception: enforce;
import std.array: empty;
import std.typetuple: TypeTuple;

enum ON_INHEAP = 1;

struct Image {
    uint w, h;
    ubyte[0] pix;
}

Image* imageNew(in uint w, in uint h) nothrow @nogc
in {
    assert(w > 0 && h > 0);
} out(result) {
    assert(result != null);
} body {
    auto im = cast(Image*)malloc(Image.sizeof + w * h * 3);
    im.w = w;
    im.h = h;
    return im;
}

Image* readPPM6(in string fileName)
in {
    assert(!fileName.empty);
} out(result) {
    assert(result != null);
} body {
    auto fIn = File(fileName, "rb");
    enforce(fIn.readln.strip == "P6");

    // Skip comments.
    string line;
    do {
        line = fIn.readln;
    } while (line.length && line[0] == '#');

    const size = line.split.to!(uint[]);
    enforce(size.length == 2);
    //immutable size = line.split.to!(uint[2]);
    auto img = imageNew(size[0], size[1]);
    enforce(fIn.readln.strip == "255");
    fIn.rawRead(img.pix.ptr[0 .. img.w * img.h * 3]);
    return img;
}

void writePPM6(in Image* img, in string fileName)
in {
    assert(!fileName.empty);
    assert(img != null);
} body {
    auto fOut = File(fileName, "wb");
    fOut.writefln("P6\n%d %d\n255", img.w, img.h);
    fOut.rawWrite(img.pix.ptr[0 .. img.w * img.h * 3]);
    fOut.close;
}

struct OctreeNode {
    long r, g, b; // Sum of all child node colors.
    uint count, heapIdx;
    ubyte nKids, kidIdx, flags, depth;
    OctreeNode*[8] kids;
    OctreeNode* parent;
}

struct HeapNode {
    uint alloc, n;
    OctreeNode** buf;
}

int cmpOctreeNode(in OctreeNode* a, in OctreeNode* b)
pure nothrow @safe @nogc
in {
    assert(a != null);
    assert(b != null);
} out(result) {
    assert(result == -1 || result == 0 || result == 1);
} body {
    if (a.nKids < b.nKids)
        return -1;
    if (a.nKids > b.nKids)
        return 1;

    immutable uint ac = a.count >> a.depth;
    immutable uint bc = b.count >> b.depth;
    return (ac < bc) ? -1 : (ac > bc);
}

void downHeap(HeapNode* h, OctreeNode* p) pure nothrow @nogc
in {
    assert(h != null);
    assert(p != null);
} body {
    auto n = p.heapIdx;

    while (true) {
        uint m = n * 2;
        if (m >= h.n)
            break;
        if (m + 1 < h.n && cmpOctreeNode(h.buf[m], h.buf[m + 1]) > 0)
            m++;

        if (cmpOctreeNode(p, h.buf[m]) <= 0)
            break;

        h.buf[n] = h.buf[m];
        h.buf[n].heapIdx = n;
        n = m;
    }

    h.buf[n] = p;
    p.heapIdx = n;
}

void upHeap(HeapNode* h, OctreeNode* p) pure nothrow @nogc
in {
    assert(h != null);
    assert(p != null);
} body {
    auto n = p.heapIdx;

    while (n > 1) {
        auto prev = h.buf[n / 2];
        if (cmpOctreeNode(p, prev) >= 0)
            break;

        h.buf[n] = prev;
        prev.heapIdx = n;
        n /= 2;
    }

    h.buf[n] = p;
    p.heapIdx = n;
}

void addHeap(HeapNode* h, OctreeNode* p) nothrow @nogc
in {
    assert(h != null);
    assert(p != null);
} body {
    if ((p.flags & ON_INHEAP)) {
        downHeap(h, p);
        upHeap(h, p);
        return;
    }

    p.flags |= ON_INHEAP;
    if (!h.n)
        h.n = 1;
    if (h.n >= h.alloc) {
        while (h.n >= h.alloc)
            h.alloc += 1024;
        h.buf = cast(OctreeNode**)realloc(h.buf, (OctreeNode*).sizeof * h.alloc);
        assert(h.buf != null);
    }

    p.heapIdx = h.n;
    h.buf[h.n++] = p;
    upHeap(h, p);
}

OctreeNode* popHeap(HeapNode* h) pure nothrow @nogc
in {
    assert(h != null);
} out(result) {
    assert(result != null);
} body {
    if (h.n <= 1)
        return null;

    auto ret = h.buf[1];
    h.buf[1] = h.buf[--h.n];

    h.buf[h.n] = null;

    h.buf[1].heapIdx = 1;
    downHeap(h, h.buf[1]);

    return ret;
}

OctreeNode* octreeNodeNew(in ubyte idx, in ubyte depth, OctreeNode* p,
                          ref OctreeNode[] pool) nothrow @nogc
out(result) {
    assert(result != null);
} body {
    __gshared static uint len = 0;

    if (len <= 1) {
        OctreeNode* p2 = cast(OctreeNode*)calloc(OctreeNode.sizeof, 2048);
        assert(p2 != null);
        p2.parent = pool.ptr;
        pool = p2[0 .. 2048];
        len = 2047;
    }

    OctreeNode* x = pool.ptr + len--;
    x.kidIdx = idx;
    x.depth = depth;
    x.parent = p;
    if (p)
        p.nKids++;
    return x;
}

void octreeNodeFree(ref OctreeNode[] pool) nothrow @nogc
out {
    assert(pool.empty);
} body {
    auto poolPtr = pool.ptr;

    while (poolPtr) {
        auto p = poolPtr.parent;
        free(poolPtr);
        poolPtr = p;
    }

    pool = null;
}

OctreeNode* octreeNodeInsert(OctreeNode* root, in ubyte* pix, ref OctreeNode[] pool)
nothrow @nogc
in {
    assert(root != null);
    assert(pix != null);
    assert(!pool.empty);
} out(result) {
    assert(result != null);
} body {
    ubyte depth = 0;

    for (ubyte bit = (1 << 7); ++depth < 8; bit >>= 1) {
        immutable ubyte i = !!(pix[1] & bit) * 4 +
                            !!(pix[0] & bit) * 2 +
                            !!(pix[2] & bit);
        if (!root.kids[i])
            root.kids[i] = octreeNodeNew(i, depth, root, pool);

        root = root.kids[i];
    }

    root.r += pix[0];
    root.g += pix[1];
    root.b += pix[2];
    root.count++;
    return root;
}

OctreeNode* octreeNodeFold(OctreeNode* p) nothrow @nogc
in {
    assert(p != null);
} out(result) {
    assert(result != null);
} body {
    if (p.nKids)
        abort();
    auto q = p.parent;
    q.count += p.count;

    q.r += p.r;
    q.g += p.g;
    q.b += p.b;
    q.nKids--;
    q.kids[p.kidIdx] = null;
    return q;
}

void colorReplace(OctreeNode* root, ubyte* pix) pure nothrow @nogc
in {
    assert(root != null);
    assert(pix != null);
} body {
    for (ubyte bit = (1 << 7); bit; bit >>= 1) {
        immutable i = !!(pix[1] & bit) * 4 +
                      !!(pix[0] & bit) * 2 +
                      !!(pix[2] & bit);
        if (!root.kids[i])
            break;
        root = root.kids[i];
    }

    pix[0] = cast(ubyte)root.r;
    pix[1] = cast(ubyte)root.g;
    pix[2] = cast(ubyte)root.b;
}

void errorDiffuse(Image* im, HeapNode* h) nothrow @nogc
in {
    assert(im != null);
    assert(h != null);
} body {
    OctreeNode* nearestColor(in int* v) nothrow @nogc
    in {
        assert(v != null);
    } out(result) {
        assert(result != null);
    } body {
        auto max = long.max;
        typeof(return) on = null;

        foreach (immutable uint i; 1 .. h.n) {
            immutable diff = 3 * abs(h.buf[i].r - v[0]) +
                             5 * abs(h.buf[i].g - v[1]) +
                             2 * abs(h.buf[i].b - v[2]);
            if (diff < max) {
                max = diff;
                on = h.buf[i];
            }
        }

        return on;
    }

    uint pos(in uint i, in uint j) nothrow @safe @nogc {
        return 3 * (i * im.w + j);
    }

    enum C10 = 7;
    enum C01 = 5;
    enum C11 = 2;
    enum C00 = 1;
    enum CTOTAL = C00 + C11 + C10 + C01;

    auto npx = cast(int*)calloc(int.sizeof, im.h * im.w * 3);
    assert(npx != null);
    auto pix = im.pix.ptr;
    alias triple = TypeTuple!(0, 1, 2);

    for (auto px = npx, i = 0u; i < im.h; i++) {
        for (uint j = 0; j < im.w; j++, pix += 3, px += 3) {
            /*static*/ foreach (immutable k; triple)
                px[k] = cast(int)pix[k] * CTOTAL;
        }
    }

    static void clamp(ref int x) pure nothrow @safe @nogc {
        if (x > 255) x = 255;
        if (x < 0)   x = 0;
    }

    pix = im.pix.ptr;

    for (auto px = npx, i = 0u; i < im.h; i++) {
        for (uint j = 0; j < im.w; j++, pix += 3, px += 3) {
            /*static*/ foreach (immutable k; triple)
                px[k] /= CTOTAL;
            /*static*/ foreach (immutable k; triple)
                clamp(px[k]);

            const nd = nearestColor(px);
            uint[3] v = void;
            v[0] = cast(uint)(px[0] - nd.r);
            v[1] = cast(uint)(px[1] - nd.g);
            v[2] = cast(uint)(px[2] - nd.b);

            pix[0] = cast(ubyte)nd.r;
            pix[1] = cast(ubyte)nd.g;
            pix[2] = cast(ubyte)nd.b;

            if (j < im.w - 1) {
                /*static*/ foreach (immutable k; triple)
                    npx[pos(i, j + 1) + k] += v[k] * C10;
            }

            if (i >= im.h - 1)
                continue;

            /*static*/ foreach (immutable k; triple)
                npx[pos(i + 1, j) + k] += v[k] * C01;

            if (j < im.w - 1) {
                /*static*/ foreach (immutable k; triple)
                    npx[pos(i + 1, j + 1) + k] += v[k] * C11;
            }

            if (j) {
                /*static*/ foreach (immutable k; triple)
                    npx[pos(i + 1, j - 1) + k] += v[k] * C00;
            }
        }
    }

    free(npx);
}

void colorQuant(Image* im, in uint nColors, in bool dither) nothrow @nogc
in {
    assert(im != null);
    assert(nColors > 1);
} body {
    auto pix = im.pix.ptr;
    HeapNode heap = { 0, 0, null };
    OctreeNode[] pool;

    auto root = octreeNodeNew(0, 0, null, pool);
    for (uint i = 0; i < im.w * im.h; i++, pix += 3)
        addHeap(&heap, octreeNodeInsert(root, pix, pool));

    while (heap.n > nColors + 1)
        addHeap(&heap, octreeNodeFold(popHeap(&heap)));

    foreach (immutable i; 1 .. heap.n) {
        auto got = heap.buf[i];
        immutable double c = got.count;
        got.r = cast(long)(got.r / c + 0.5);
        got.g = cast(long)(got.g / c + 0.5);
        got.b = cast(long)(got.b / c + 0.5);
    }

    if (dither)
        errorDiffuse(im, &heap);
    else {
        uint i;
        for (i = 0, pix = im.pix.ptr; i < im.w * im.h; i++, pix += 3)
            colorReplace(root, pix);
    }

    pool.octreeNodeFree;
    heap.buf.free;
}

int main(in string[] args) {
    if (args.length < 3 || args.length > 4) {
        stderr.writeln("Usage: quant ppmFile nColors [dith]");
        return 1;
    }

    immutable nColors = args[2].to!uint;
    assert(nColors > 1);

    auto im = readPPM6(args[1]);
    immutable useDithering = (args.length == 4) ? (args[3] == "dith") : false;
    immutable fileNameOut = useDithering ? "outd.ppm" : "out.ppm";

    colorQuant(im, nColors, useDithering);
    writePPM6(im, fileNameOut);

    im.free;
    return 0;
}
