// Implmentation following pseudocode from
// "An introductory tutorial on kd-trees" by Andrew W. Moore,
// Carnegie Mellon University, PDF accessed from:
// http://www.autonlab.org/autonweb/14665

import std.typecons, std.math, std.algorithm, std.random, std.range,
       std.traits, core.memory;

/// k-dimensional point.
struct Point(size_t k, F) if (isFloatingPoint!F) {
    F[k] data;
    alias data this; // Kills DMD std.algorithm.swap inlining.
                     // Define opIndexAssign and opIndex for dmd.
    enum size_t length = k;

    /// Square of the euclidean distance.
    double sqd(in ref Point!(k, F) q) const pure nothrow @nogc {
        double sum = 0;
        foreach (immutable dim, immutable pCoord; data)
            sum += (pCoord - q[dim]) ^^ 2;
        return sum;
    }
}

// Following field names in the paper.
// rangeElt would be whatever data is associated with the Point.
// We don't bother with it for this example.
struct KdNode(size_t k, F) {
    Point!(k, F) domElt;
    immutable int split;
    typeof(this)* left, right;
}

struct Orthotope(size_t k, F) { /// k-dimensional rectangle.
    Point!(k, F) min, max;
}

struct KdTree(size_t k, F) {
    KdNode!(k, F)* n;
    Orthotope!(k, F) bounds;

    // Constructs a KdTree from a list of points, also associating the
    // bounds of the tree. The bounds could be computed of course, but
    // in this example we know them already. The algorithm is table
    // 6.3 in the paper.
    this(Point!(k, F)[] pts, in Orthotope!(k, F) bounds_) pure {
        static KdNode!(k, F)* nk2(size_t split)(Point!(k, F)[] exset)
        pure {
            if (exset.empty)
                return null;
            if (exset.length == 1)
                return new KdNode!(k, F)(exset[0], split, null, null);

            // Pivot choosing procedure. We find median, then find
            // largest index of points with median value. This
            // satisfies the inequalities of steps 6 and 7 in the
            // algorithm.
            auto m = exset.length / 2;
            topN!((p, q) => p[split] < q[split])(exset, m);
            immutable d = exset[m];
            while (m+1 < exset.length && exset[m+1][split] == d[split])
                m++;

            enum nextSplit = (split + 1) % d.length;//cycle coordinates
            return new KdNode!(k, F)(d, split,
                                     nk2!nextSplit(exset[0 .. m]),
                                     nk2!nextSplit(exset[m + 1 .. $]));
        }

        this.n = nk2!0(pts);
        this.bounds = bounds_;
    }
}

/**
Find nearest neighbor. Return values are:
  nearest neighbor--the ooint within the tree that is nearest p.
  square of the distance to that point.
  a count of the nodes visited in the search.
*/
auto findNearest(size_t k, F)(KdTree!(k, F) t, in Point!(k, F) p)
pure nothrow @nogc {
    // Algorithm is table 6.4 from the paper, with the addition of
    // counting the number nodes visited.
    static Tuple!(Point!(k, F), "nearest",
                  F, "distSqd",
                  int, "nodesVisited")
           nn(KdNode!(k, F)* kd, in Point!(k, F) target,
              Orthotope!(k, F) hr, F maxDistSqd) pure nothrow @nogc {
        if (kd == null)
            return typeof(return)(Point!(k, F)(), F.infinity, 0);

        int nodesVisited = 1;
        immutable s = kd.split;
        auto pivot = kd.domElt;
        auto leftHr = hr;
        auto rightHr = hr;
        leftHr.max[s] = pivot[s];
        rightHr.min[s] = pivot[s];

        KdNode!(k, F)* nearerKd, furtherKd;
        Orthotope!(k, F) nearerHr, furtherHr;
        if (target[s] <= pivot[s]) {
            //nearerKd, nearerHr = kd.left, leftHr;
            //furtherKd, furtherHr = kd.right, rightHr;
            nearerKd = kd.left;
            nearerHr = leftHr;
            furtherKd = kd.right;
            furtherHr = rightHr;
        } else {
            //nearerKd, nearerHr = kd.right, rightHr;
            //furtherKd, furtherHr = kd.left, leftHr;
            nearerKd = kd.right;
            nearerHr = rightHr;
            furtherKd = kd.left;
            furtherHr = leftHr;
        }

        auto n1 = nn(nearerKd, target, nearerHr, maxDistSqd);
        auto nearest = n1.nearest;
        auto distSqd = n1.distSqd;
        nodesVisited += n1.nodesVisited;

        if (distSqd < maxDistSqd)
            maxDistSqd = distSqd;
        auto d = (pivot[s] - target[s]) ^^ 2;
        if (d > maxDistSqd)
            return typeof(return)(nearest, distSqd, nodesVisited);
        d = pivot.sqd(target);
        if (d < distSqd) {
            nearest = pivot;
            distSqd = d;
            maxDistSqd = distSqd;
        }

        immutable n2 = nn(furtherKd, target, furtherHr, maxDistSqd);
        nodesVisited += n2.nodesVisited;
        if (n2.distSqd < distSqd) {
            nearest = n2.nearest;
            distSqd = n2.distSqd;
        }

        return typeof(return)(nearest, distSqd, nodesVisited);
    }

    return nn(t.n, p, t.bounds, F.infinity);
}

void showNearest(size_t k, F)(in string heading, KdTree!(k, F) kd,
                              in Point!(k, F) p) {
    import std.stdio: writeln;
    writeln(heading, ":");
    writeln("Point:            ", p);
    immutable n = kd.findNearest(p);
    writeln("Nearest neighbor: ", n.nearest);
    writeln("Distance:         ", sqrt(n.distSqd));
    writeln("Nodes visited:    ", n.nodesVisited, "\n");
}

void main() {
    static Point!(k, F) randomPoint(size_t k, F)() {
        typeof(return) result;
        foreach (immutable i; 0 .. k)
            result[i] = uniform(F(0), F(1));
        return result;
    }

    static Point!(k, F)[] randomPoints(size_t k, F)(in size_t n) {
        return n.iota.map!(_ => randomPoint!(k, F)).array;
    }

    import std.stdio, std.conv, std.datetime, std.typetuple;
    rndGen.seed(1); // For repeatable outputs.

    alias D2 = TypeTuple!(2, double);
    alias P = Point!D2;
    auto kd1 = KdTree!D2([P([2, 3]), P([5, 4]), P([9, 6]),
                          P([4, 7]), P([8, 1]), P([7, 2])],
                         Orthotope!D2(P([0, 0]), P([10, 10])));
    showNearest("Wikipedia example data", kd1, P([9, 2]));

    enum int N = 400_000;
    alias F3 = TypeTuple!(3, float);
    alias Q = Point!F3;
    StopWatch sw;
    GC.disable;
    sw.start;
    auto kd2 = KdTree!F3(randomPoints!F3(N),
                         Orthotope!F3(Q([0, 0, 0]), Q([1, 1, 1])));
    sw.stop;
    GC.enable;
    showNearest(text("k-d tree with ", N,
                     " random 3D ", F3[1].stringof,
                     " points (construction time: ",
                     sw.peek.msecs, " ms)"), kd2, randomPoint!F3);

    sw.reset;
    sw.start;
    enum int M = 10_000;
    size_t visited = 0;
    foreach (immutable _; 0 .. M) {
        immutable n = kd2.findNearest(randomPoint!F3);
        visited += n.nodesVisited;
    }
    sw.stop;

    writefln("Visited an average of %0.2f nodes on %d searches " ~
             "in %d ms.", visited / double(M), M, sw.peek.msecs);
}
