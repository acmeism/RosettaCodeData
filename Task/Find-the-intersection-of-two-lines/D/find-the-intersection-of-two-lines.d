import std.stdio;

struct Point {
    real x, y;

    void toString(scope void delegate(const(char)[]) sink) const {
        import std.format;
        sink("{");
        sink.formattedWrite!"%f"(x);
        sink(", ");
        sink.formattedWrite!"%f"(y);
        sink("}");
    }
}

struct Line {
    Point s, e;
}

Point findIntersection(Line l1, Line l2) {
    auto a1 = l1.e.y - l1.s.y;
    auto b1 = l1.s.x - l1.e.x;
    auto c1 = a1 * l1.s.x + b1 * l1.s.y;

    auto a2 = l2.e.y - l2.s.y;
    auto b2 = l2.s.x - l2.e.x;
    auto c2 = a2 * l2.s.x + b2 * l2.s.y;

    auto delta = a1 * b2 - a2 * b1;
    // If lines are parallel, intersection point will contain infinite values
    return Point((b2 * c1 - b1 * c2) / delta, (a1 * c2 - a2 * c1) / delta);
}

void main() {
    auto l1 = Line(Point(4.0, 0.0), Point(6.0, 10.0));
    auto l2 = Line(Point(0f, 3f), Point(10f, 7f));
    writeln(findIntersection(l1, l2));
    l1 = Line(Point(0.0, 0.0), Point(1.0, 1.0));
    l2 = Line(Point(1.0, 2.0), Point(4.0, 5.0));
    writeln(findIntersection(l1, l2));
}
