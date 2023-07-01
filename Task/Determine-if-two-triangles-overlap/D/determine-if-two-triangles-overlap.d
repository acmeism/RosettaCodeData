import std.stdio;
import std.typecons;

alias Pair = Tuple!(real, real);

struct Triangle {
    Pair p1;
    Pair p2;
    Pair p3;

    void toString(scope void delegate(const(char)[]) sink) const {
        import std.format;
        sink("Triangle: ");
        formattedWrite!"%s"(sink, p1);
        sink(", ");
        formattedWrite!"%s"(sink, p2);
        sink(", ");
        formattedWrite!"%s"(sink, p3);
    }
}

auto det2D(Triangle t) {
    return t.p1[0] *(t.p2[1] - t.p3[1])
         + t.p2[0] *(t.p3[1] - t.p1[1])
         + t.p3[0] *(t.p1[1] - t.p2[1]);
}

void checkTriWinding(Triangle t, bool allowReversed) {
    auto detTri = t.det2D();
    if (detTri < 0.0) {
        if (allowReversed) {
            auto a = t.p3;
            t.p3 = t.p2;
            t.p2 = a;
        } else {
            throw new Exception("Triangle has wrong winding direction");
        }
    }
}

auto boundaryCollideChk(Triangle t, real eps) {
    return t.det2D() < eps;
}

auto boundaryDoesntCollideChk(Triangle t, real eps) {
    return t.det2D() <= eps;
}

bool triTri2D(Triangle t1, Triangle t2, real eps = 0.0, bool allowReversed = false, bool onBoundary = true) {
    // Triangles must be expressed anti-clockwise
    checkTriWinding(t1, allowReversed);
    checkTriWinding(t2, allowReversed);
    // 'onBoundary' determines whether points on boundary are considered as colliding or not
    auto chkEdge = onBoundary ? &boundaryCollideChk : &boundaryDoesntCollideChk;
    auto lp1 = [t1.p1, t1.p2, t1.p3];
    auto lp2 = [t2.p1, t2.p2, t2.p3];

    // for each edge E of t1
    foreach (i; 0..3) {
        auto j = (i + 1) % 3;
        // Check all points of t2 lay on the external side of edge E.
        // If they do, the triangles do not overlap.
        if (chkEdge(Triangle(lp1[i], lp1[j], lp2[0]), eps) &&
            chkEdge(Triangle(lp1[i], lp1[j], lp2[1]), eps) &&
            chkEdge(Triangle(lp1[i], lp1[j], lp2[2]), eps)) {
            return false;
        }
    }

    // for each edge E of t2
    foreach (i; 0..3) {
        auto j = (i + 1) % 3;
        // Check all points of t1 lay on the external side of edge E.
        // If they do, the triangles do not overlap.
        if (chkEdge(Triangle(lp2[i], lp2[j], lp1[0]), eps) &&
            chkEdge(Triangle(lp2[i], lp2[j], lp1[1]), eps) &&
            chkEdge(Triangle(lp2[i], lp2[j], lp1[2]), eps)) {
            return false;
        }
    }

    // The triangles overlap
    return true;
}

void overlap(Triangle t1, Triangle t2, real eps = 0.0, bool allowReversed = false, bool onBoundary = true) {
    if (triTri2D(t1, t2, eps, allowReversed, onBoundary)) {
        writeln("overlap");
    } else {
        writeln("do not overlap");
    }
}

void main() {
    auto t1 = Triangle(Pair(0.0, 0.0), Pair(5.0, 0.0), Pair(0.0, 5.0));
    auto t2 = Triangle(Pair(0.0, 0.0), Pair(5.0, 0.0), Pair(0.0, 6.0));
    writeln(t1, " and\n", t2);
    overlap(t1, t2);
    writeln;

    // need to allow reversed for this pair to avoid exception
    t1 = Triangle(Pair(0.0, 0.0), Pair(0.0, 5.0), Pair(5.0, 0.0));
    t2 = t1;
    writeln(t1, " and\n", t2);
    overlap(t1, t2, 0.0, true);
    writeln;

    t1 = Triangle(Pair(0.0, 0.0), Pair(5.0, 0.0), Pair(0.0, 5.0));
    t2 = Triangle(Pair(-10.0, 0.0), Pair(-5.0, 0.0), Pair(-1.0, 6.0));
    writeln(t1, " and\n", t2);
    overlap(t1, t2);
    writeln;

    t1.p3 = Pair(2.5, 5.0);
    t2 = Triangle(Pair(0.0, 4.0), Pair(2.5, -1.0), Pair(5.0, 4.0));
    writeln(t1, " and\n", t2);
    overlap(t1, t2);
    writeln;

    t1 = Triangle(Pair(0.0, 0.0), Pair(1.0, 1.0), Pair(0.0, 2.0));
    t2 = Triangle(Pair(2.0, 1.0), Pair(3.0, 0.0), Pair(3.0, 2.0));
    writeln(t1, " and\n", t2);
    overlap(t1, t2);
    writeln;

    t2 = Triangle(Pair(2.0, 1.0), Pair(3.0, -2.0), Pair(3.0, 4.0));
    writeln(t1, " and\n", t2);
    overlap(t1, t2);
    writeln;

    t1 = Triangle(Pair(0.0, 0.0), Pair(1.0, 0.0), Pair(0.0, 1.0));
    t2 = Triangle(Pair(1.0, 0.0), Pair(2.0, 0.0), Pair(1.0, 1.1));
    writeln(t1, " and\n", t2);
    writeln("which have only a single corner in contact, if boundary points collide");
    overlap(t1, t2);
    writeln;

    writeln(t1, " and\n", t2);
    writeln("which have only a single corner in contact, if boundary points do not collide");
    overlap(t1, t2, 0.0, false, false);
}
