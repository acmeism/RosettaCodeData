import std.algorithm.sorting;
import std.stdio;

struct Point {
    int x;
    int y;

    int opCmp(Point rhs) {
        if (x < rhs.x) return -1;
        if (rhs.x < x) return 1;
        return 0;
    }

    void toString(scope void delegate(const(char)[]) sink) const {
        import std.format;
        sink("(");
        formattedWrite(sink, "%d", x);
        sink(",");
        formattedWrite(sink, "%d", y);
        sink(")");
    }
}

Point[] convexHull(Point[] p) {
    if (p.length == 0) return [];
    p.sort;
    Point[] h;

    // lower hull
    foreach (pt; p) {
        while (h.length >= 2 && !ccw(h[$-2], h[$-1], pt)) {
            h.length--;
        }
        h ~= pt;
    }

    // upper hull
    auto t = h.length + 1;
    foreach_reverse (i; 0..(p.length - 1)) {
        auto pt = p[i];
        while (h.length >= t && !ccw(h[$-2], h[$-1], pt)) {
            h.length--;
        }
        h ~= pt;
    }

    h.length--;
    return h;
}

/* ccw returns true if the three points make a counter-clockwise turn */
auto ccw(Point a, Point b, Point c) {
    return ((b.x - a.x) * (c.y - a.y)) > ((b.y - a.y) * (c.x - a.x));
}

void main() {
    auto points = [
        Point(16,  3), Point(12, 17), Point( 0,  6), Point(-4, -6), Point(16,  6),
        Point(16, -7), Point(16, -3), Point(17, -4), Point( 5, 19), Point(19, -8),
        Point( 3, 16), Point(12, 13), Point( 3, -4), Point(17,  5), Point(-3, 15),
        Point(-3, -9), Point( 0, 11), Point(-9, -3), Point(-4, -2), Point(12, 10)
    ];
    auto hull = convexHull(points);
    writeln("Convex Hull: ", hull);
}
