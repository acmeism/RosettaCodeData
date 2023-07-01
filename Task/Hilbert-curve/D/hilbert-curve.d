import std.stdio;

void main() {
    foreach (order; 1..6) {
        int n = 1 << order;
        auto points = getPointsForCurve(n);
        writeln("Hilbert curve, order=", order);
        auto lines = drawCurve(points, n);
        foreach (line; lines) {
            writeln(line);
        }
        writeln;
    }
}

struct Point {
    int x, y;

    //rotate/flip a quadrant appropriately
    void rot(int n, bool rx, bool ry) {
        if (!ry) {
            if (rx) {
                x = (n - 1) - x;
                y = (n - 1) - y;
            }

            import std.algorithm.mutation;
            swap(x, y);
        }
    }

    int calcD(int n) {
        bool rx, ry;
        int d;
        for (int s = n >>> 1; s > 0; s >>>= 1) {
            rx = ((x & s) != 0);
            ry = ((y & s) != 0);
            d += s * s * ((rx ? 3 : 0) ^ (ry ? 1 : 0));
            rot(s, rx, ry);
        }
        return d;
    }

    void toString(scope void delegate(const(char)[]) sink) const {
        import std.format : formattedWrite;

        sink("(");
        sink.formattedWrite!"%d"(x);
        sink(", ");
        sink.formattedWrite!"%d"(y);
        sink(")");
    }
}

auto fromD(int n, int d) {
    Point p;
    bool rx, ry;
    int t = d;
    for (int s = 1; s < n; s <<= 1) {
        rx = ((t & 2) != 0);
        ry = (((t ^ (rx ? 1 : 0)) & 1) != 0);
        p.rot(s, rx, ry);
        p.x += (rx ? s : 0);
        p.y += (ry ? s : 0);
        t >>>= 2;
    }
    return p;
}

auto getPointsForCurve(int n) {
    Point[] points;
    for (int d; d < n * n; ++d) {
        points ~= fromD(n, d);
    }
    return points;
}

auto drawCurve(Point[] points, int n) {
    import std.algorithm.comparison : min, max;
    import std.array : uninitializedArray;
    import std.exception : enforce;

    auto canvas = uninitializedArray!(char[][])(n, n * 3 - 2);
    foreach (line; canvas) {
        line[] =  ' ';
    }

    for (int i = 1; i < points.length; ++i) {
        auto lastPoint = points[i - 1];
        auto curPoint = points[i];
        int deltaX = curPoint.x - lastPoint.x;
        int deltaY = curPoint.y - lastPoint.y;
        if (deltaX == 0) {
            enforce(deltaY != 0, "Duplicate point");
            // vertical line
            int row = max(curPoint.y, lastPoint.y);
            int col = curPoint.x * 3;
            canvas[row][col] = '|';
        } else {
            enforce(deltaY == 0, "Diagonal line");
            // horizontal line
            int row = curPoint.y;
            int col = min(curPoint.x, lastPoint.x) * 3 + 1;
            canvas[row][col] = '_';
            canvas[row][col + 1] = '_';
        }
    }

    string[] lines;
    foreach (row; canvas) {
        lines ~= row.idup;
    }

    return lines;
}
