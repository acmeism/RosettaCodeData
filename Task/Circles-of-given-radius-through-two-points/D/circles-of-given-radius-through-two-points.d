import std.stdio, std.typecons, std.math;

class ValueException : Exception {
    this(string msg_) pure { super(msg_); }
}

struct V2 { double x, y; }
struct Circle { double x, y, r; }

/**Following explanation at:
http://mathforum.org/library/drmath/view/53027.html
*/
Tuple!(Circle, Circle)
circlesFromTwoPointsAndRadius(in V2 p1, in V2 p2, in double r)
pure in {
    assert(r >= 0, "radius can't be negative");
} body {
    enum nBits = 40;

    if (r.abs < (1.0 / (2.0 ^^ nBits)))
        throw new ValueException("radius of zero");

    if (feqrel(p1.x, p2.x) >= nBits &&
        feqrel(p1.y, p2.y) >= nBits)
        throw new ValueException("coincident points give" ~
                                 " infinite number of Circles");

    // Delta between points.
    immutable d = V2(p2.x - p1.x, p2.y - p1.y);

    // Distance between points.
    immutable q = sqrt(d.x ^^ 2 + d.y ^^ 2);
    if (q > 2.0 * r)
        throw new ValueException("separation of points > diameter");

    // Halfway point.
    immutable h = V2((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);

    // Distance along the mirror line.
    immutable dm = sqrt(r ^^ 2 - (q / 2) ^^ 2);

    return typeof(return)(
        Circle(h.x - dm * d.y / q, h.y + dm * d.x / q, r.abs),
        Circle(h.x + dm * d.y / q, h.y - dm * d.x / q, r.abs));
}

void main() {
    foreach (immutable t; [
                 tuple(V2(0.1234, 0.9876), V2(0.8765, 0.2345), 2.0),
                 tuple(V2(0.0000, 2.0000), V2(0.0000, 0.0000), 1.0),
                 tuple(V2(0.1234, 0.9876), V2(0.1234, 0.9876), 2.0),
                 tuple(V2(0.1234, 0.9876), V2(0.8765, 0.2345), 0.5),
                 tuple(V2(0.1234, 0.9876), V2(0.1234, 0.9876), 0.0)]) {
        writefln("Through points:\n  %s   %s  and radius %f\n" ~
                 "You can construct the following circles:", t[]);
        try {
            writefln("  %s\n  %s\n",
                     circlesFromTwoPointsAndRadius(t[])[]);
        } catch (ValueException v)
            writefln("  ERROR: %s\n", v.msg);
    }
}
