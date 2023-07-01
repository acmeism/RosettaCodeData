import std.stdio;

Point[] pnts = [{3,4}, {5,11}, {12,8}, {9,5}, {5,6}];

void main() {
    auto ans = shoelace(pnts);
    writeln(ans);
}

struct Point {
    real x, y;
}

real shoelace(Point[] pnts) {
    real leftSum = 0, rightSum = 0;

    for (int i=0; i<pnts.length; ++i) {
        int j = (i+1) % pnts.length;
        leftSum  += pnts[i].x * pnts[j].y;
        rightSum += pnts[j].x * pnts[i].y;
    }

    import std.math : abs;
    return 0.5 * abs(leftSum - rightSum);
}

unittest {
    auto ans = shoelace(pnts);
    assert(ans == 30);
}
