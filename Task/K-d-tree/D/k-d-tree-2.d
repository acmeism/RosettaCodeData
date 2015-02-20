import std.stdio, std.algorithm, std.math, std.random, std.typecons;

enum maxDim = 3;

struct KdNode {
    double[maxDim] x;
    KdNode* left, right;
}

// See QuickSelect method.
KdNode* findMedian(size_t idx)(KdNode[] nodes) pure nothrow @nogc {
    auto start = nodes.ptr;
    auto end = &nodes[$ - 1] + 1;

    if (end <= start)
        return null;
    if (end == start + 1)
        return start;

    KdNode* md = start + (end - start) / 2;

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

KdNode* makeTree(size_t dim, size_t i)(KdNode[] nodes)
pure nothrow @nogc {
    if (!nodes.length)
        return null;

    auto n = findMedian!i(nodes);
    if (n != null) {
        enum i2 = (i + 1) % dim;
        immutable size_t nPos = n - nodes.ptr;
        n.left  = makeTree!(dim, i2)(nodes[0 .. nPos]);
        n.right = makeTree!(dim, i2)(nodes[nPos + 1 .. $]);
    }

    return n;
}

void nearest(size_t dim)(in KdNode* root,
                         in ref KdNode nd,
                         in size_t i,
                         ref const(KdNode)* best,
                         ref double bestDist,
                         ref size_t nVisited) pure nothrow @safe @nogc {
    static double dist(in ref KdNode a, in ref KdNode b)
    pure nothrow @nogc {
        typeof(KdNode.x[0]) result = 0;
        foreach (immutable i; staticIota!(0, dim))
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

void randPt(size_t dim=3)(ref KdNode v, ref Xorshift rng)
pure nothrow @safe @nogc {
    foreach (immutable i; staticIota!(0, dim))
        v.x[i] = rng.uniform01;
}

void smallTest() {
    KdNode[] wp = [{[2, 3]}, {[5, 4]}, {[9, 6]},
                   {[4, 7]}, {[8, 1]}, {[7, 2]}];
    KdNode thisPt = {[9, 2]};

    KdNode* root = makeTree!(2, 0)(wp);

    const(KdNode)* found = null;
    double bestDist = 0;
    size_t nVisited = 0;
    nearest!2(root, thisPt, 0, found, bestDist, nVisited);

    writefln("WP tree:\n  Searching for %s\n" ~
             "  Found %s, dist = %g\n  Seen %d nodes.\n",
             thisPt.x[0..2], found.x[0..2], sqrt(bestDist), nVisited);
}

void bigTest() {
    enum N = 1_000_000;
    enum testRuns = 100_000;

    auto bigTree = new KdNode[N];
    auto rng = 1.Xorshift;
    foreach (ref node; bigTree)
        randPt(node, rng);

    KdNode* root = makeTree!(3, 0)(bigTree);
    KdNode thisPt;
    randPt(thisPt, rng);

    const(KdNode)* found = null;
    double bestDist = 0;
    size_t nVisited = 0;
    nearest!3(root, thisPt, 0, found, bestDist, nVisited);

    writefln("Big tree (%d nodes):\n  Searching for %s\n"~
             "  Found %s, dist = %g\n  Seen %d nodes.",
             N, thisPt.x, found.x, sqrt(bestDist), nVisited);

    size_t sum = 0;
    foreach (immutable _; 0 .. testRuns) {
        found = null;
        nVisited = 0;
        randPt(thisPt, rng);
        nearest!3(root, thisPt, 0, found, bestDist, nVisited);
        sum += nVisited;
    }
    writefln("\nBig tree:\n  Visited %d nodes for %d random "~
             "searches (%.2f per lookup).",
             sum, testRuns, sum / double(testRuns));
}

void main() {
    smallTest;
    bigTest;
}
