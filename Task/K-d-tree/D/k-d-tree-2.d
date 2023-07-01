import std.stdio, std.algorithm, std.math, std.random;

struct KdNode(size_t dim) {
    double[dim] x;
    KdNode* left, right;
}

// See QuickSelect method.
KdNode!dim* findMedian(size_t idx, size_t dim)(KdNode!dim[] nodes) pure nothrow @nogc {
    auto start = nodes.ptr;
    auto end = &nodes[$ - 1] + 1;

    if (end <= start)
        return null;
    if (end == start + 1)
        return start;

    auto md = start + (end - start) / 2;

    while (true) {
        immutable double pivot = md.x[idx];

        swap(md.x, (end - 1).x); // Swaps the whole arrays x.
        auto store = start;
        foreach (p; start .. end) {
            if (p.x[idx] < pivot) {
                if (p != store)
                    swap(p.x, store.x);
                store++;
            }
        }
        swap(store.x, (end - 1).x);

        // Median has duplicate values.
        if (store.x[idx] == md.x[idx])
            return md;

        if (store > md)
            end = store;
        else
            start = store;
    }
}

KdNode!dim* makeTree(size_t dim, size_t i = 0)(KdNode!dim[] nodes)
pure nothrow @nogc {
    if (!nodes.length)
        return null;

    auto n = nodes.findMedian!i;
    if (n != null) {
        enum i2 = (i + 1) % dim;
        immutable size_t nPos = n - nodes.ptr;
        n.left = makeTree!(dim, i2)(nodes[0 .. nPos]);
        n.right = makeTree!(dim, i2)(nodes[nPos + 1 .. $]);
    }

    return n;
}

void nearest(size_t dim)(in KdNode!dim* root,
                         in ref KdNode!dim nd,
                         in size_t i,
                         ref const(KdNode!dim)* best,
                         ref double bestDist,
                         ref size_t nVisited) pure nothrow @safe @nogc {
    static double dist(in ref KdNode!dim a, in ref KdNode!dim b)
    pure nothrow @nogc {
        double result = 0;
        static foreach (i; 0 .. dim)
            result += (a.x[i] - b.x[i]) ^^ 2;
        return result;
    }

    if (root == null)
        return;

    immutable double d = dist(*root, nd);
    immutable double dx = root.x[i] - nd.x[i];
    immutable double dx2 = dx ^^ 2;
    nVisited++;

    if (!best || d < bestDist) {
        bestDist = d;
        best = root;
    }

    // If chance of exact match is high.
    if (!bestDist)
        return;

    immutable i2 = (i + 1 >= dim) ? 0 : i + 1;

    nearest!dim(dx > 0 ? root.left : root.right,
                nd, i2, best, bestDist, nVisited);
    if (dx2 >= bestDist)
        return;
    nearest!dim(dx > 0 ? root.right : root.left,
                nd, i2, best, bestDist, nVisited);
}

void randPt(size_t dim)(ref KdNode!dim v, ref Xorshift rng)
pure nothrow @safe @nogc {
    static foreach (i; 0 .. dim)
        v.x[i] = rng.uniform01;
}

/// smallTest
unittest {
    KdNode!2[] wp = [{[2, 3]}, {[5, 4]}, {[9, 6]},
                   {[4, 7]}, {[8, 1]}, {[7, 2]}];
    KdNode!2 thisPt = {[9, 2]};

    auto root = makeTree(wp);

    const(KdNode!2)* found = null;
    double bestDist = 0;
    size_t nVisited = 0;
    root.nearest(thisPt, 0, found, bestDist, nVisited);

    writefln("WP tree:\n  Searching for %s\n" ~
             "  Found %s, dist = %g\n  Seen %d nodes.\n",
             thisPt.x, found.x, sqrt(bestDist), nVisited);
}

/// bigTest
unittest {
    enum N = 1_000_000;
    enum testRuns = 100_000;

    auto bigTree = new KdNode!3[N];
    auto rng = 1.Xorshift;
    foreach (ref node; bigTree)
        randPt(node, rng);

    auto root = makeTree(bigTree);
    KdNode!3 thisPt;
    randPt(thisPt, rng);

    const(KdNode!3)* found = null;
    double bestDist = 0;
    size_t nVisited = 0;
    root.nearest(thisPt, 0, found, bestDist, nVisited);

    writefln("Big tree (%d nodes):\n  Searching for %s\n" ~ "  Found %s, dist = %g\n  Seen %d nodes.", N, thisPt.x, found.x, sqrt(bestDist), nVisited);

    size_t sum = 0;
    foreach (immutable _; 0 .. testRuns) {
        found = null;
        nVisited = 0;
        randPt(thisPt, rng);
        nearest!3(root, thisPt, 0, found, bestDist, nVisited);
        sum += nVisited;
    }
    writefln("\nBig tree:\n  Visited %d nodes for %d random " ~
             "searches (%.2f per lookup).",
             sum, testRuns, sum / double(testRuns));
}
