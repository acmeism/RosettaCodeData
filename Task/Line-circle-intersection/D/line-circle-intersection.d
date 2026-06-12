import std.format;
import std.math;
import std.stdio;

immutable EPS = 1e-14;

struct Point {
    private double x;
    private double y;

    public this(double x, double y) {
        this.x = x;
        this.y = y;
    }

    public double getX() {
        return x;
    }

    public double getY() {
        return y;
    }

    void toString(scope void delegate(const(char)[]) sink, FormatSpec!char fmt) const {
        double mx = x;
        double my = y;

        // eliminate negative zero
        if (mx == 0.0) {
            mx = 0.0;
        }

        // eliminate negative zero
        if (my == 0.0) {
            my = 0.0;
        }

        sink("(");
        formatValue(sink, mx, fmt);
        sink(", ");
        formatValue(sink, my, fmt);
        sink(")");
    }
}

auto sq(T)(T x) {
    return x * x;
}

auto intersects(const Point p1, const Point p2, const Point cp, double r, bool segment) {
    auto x0 = cp.x;
    auto y0 = cp.y;
    auto x1 = p1.x;
    auto y1 = p1.y;
    auto x2 = p2.x;
    auto y2 = p2.y;

    auto A = y2 - y1;
    auto B = x1 - x2;
    auto C = x2 * y1 - x1 * y2;

    auto a = sq(A) + sq(B);
    double b, c;

    bool bnz = true;

    Point[] res;

    if (abs(B) >= EPS) {
        b = 2 * (A * C + A * B * y0 - sq(B) * x0);
        c = sq(C) + 2 * B * C * y0 - sq(B) * (sq(r) - sq(x0) - sq(y0));
    } else {
        b = 2 * (B * C + A * B * x0 - sq(A) * y0);
        c = sq(C) + 2 * A * C * x0 - sq(A) * (sq(r) - sq(x0) - sq(y0));
        bnz = false;
    }

    auto d = sq(b) - 4 * a * c; // discriminant
    if (d < 0) {
        return res;
    }

    auto within(double x, double y) {
        auto d1 = sqrt(sq(x2 - x1) + sq(y2 - y1));  // distance between end-points
        auto d2 = sqrt(sq(x - x1) + sq(y - y1));    // distance from point to one end
        auto d3 = sqrt(sq(x2 - x) + sq(y2 - y));    // distance from point to other end
        auto delta = d1 - d2 - d3;
        return abs(delta) < EPS;                    // true if delta is less than a small tolerance
    }

    auto fx(double x) {
        return -(A * x + C) / B;
    }

    auto fy(double y) {
        return -(B * y + C) / A;
    }

    auto rxy(double x, double y) {
        if (!segment || within(x, y)) {
            res ~= Point(x, y);
        }
    }

    double x, y;
    if (d == 0.0) {
        // line is tangent to circle, so just one intersect at most
        if (bnz) {
            x = -b / (2 * a);
            y = fx(x);
            rxy(x, y);
        } else {
            y = -b / (2 * a);
            x = fy(y);
            rxy(x, y);
        }
    } else {
        // two intersects at most
        d = sqrt(d);
        if (bnz) {
            x = (-b + d) / (2 * a);
            y = fx(x);
            rxy(x, y);
            x = (-b - d) / (2 * a);
            y = fx(x);
            rxy(x, y);
        } else {
            y = (-b + d) / (2 * a);
            x = fy(y);
            rxy(x, y);
            y = (-b - d) / (2 * a);
            x = fy(y);
            rxy(x, y);
        }
    }

    return res;
}

void main() {
    writeln("The intersection points (if any) between:");

    auto cp = Point(3.0, -5.0);
    auto r = 3.0;
    writeln("  A circle, center ", cp, " with radius ", r, ", and:");

    auto p1 = Point(-10.0, 11.0);
    auto p2 = Point(10.0, -9.0);
    writeln("    a line containing the points ", p1, " and ", p2, " is/are:");
    writeln("     ", intersects(p1, p2, cp, r, false));

    p2 = Point(-10.0, 12.0);
    writeln("    a segment starting at ", p1, " and ending at ", p2, " is/are:");
    writeln("     ", intersects(p1, p2, cp, r, true));

    p1 = Point(3.0, -2.0);
    p2 = Point(7.0, -2.0);
    writeln("    a horizontal line containing the points ", p1, " and ", p2, " is/are:");
    writeln("     ", intersects(p1, p2, cp, r, false));

    cp = Point(0.0, 0.0);
    r = 4.0;
    writeln("  A circle, center ", cp, " with radius ", r, ", and:");

    p1 = Point(0.0, -3.0);
    p2 = Point(0.0, 6.0);
    writeln("    a vertical line containing the points ", p1, " and ", p2, " is/are:");
    writeln("     ", intersects(p1, p2, cp, r, false));
    writeln("    a vertical segment containing the points ", p1, " and ", p2, " is/are:");
    writeln("     ", intersects(p1, p2, cp, r, true));

    cp = Point(4.0, 2.0);
    r = 5.0;
    writeln("  A circle, center ", cp, " with radius ", r, ", and:");

    p1 = Point(6.0, 3.0);
    p2 = Point(10.0, 7.0);
    writeln("    a line containing the points ", p1, " and ", p2, " is/are:");
    writeln("     ", intersects(p1, p2, cp, r, false));

    p1 = Point(7.0, 4.0);
    p2 = Point(11.0, 8.0);
    writeln("    a segment starting at ", p1, " and ending at ", p2, " is/are:");
    writeln("     ", intersects(p1, p2, cp, r, true));
}
