import "./sort" for Sort
import "./trait" for Comparable
import "./iterate" for Stepped

class Point is Comparable {
    construct new(x, y) {
        _x = x
        _y = y
    }

    x { _x }
    y { _y }

    compare(other) { (_x != other.x) ? (_x - other.x).sign : (_y - other.y).sign }

    toString { "(%(_x), %(_y))" }
}

/* ccw returns true if the three points make a counter-clockwise turn */
var ccw = Fn.new { |a, b, c| ((b.x - a.x) * (c.y - a.y)) > ((b.y - a.y) * (c.x - a.x)) }

var convexHull = Fn.new { |pts|
    if (pts.isEmpty) return []
    Sort.quick(pts)
    var h = []

    // lower hull
    for (pt in pts) {
        while (h.count >= 2 && !ccw.call(h[-2], h[-1], pt)) h.removeAt(-1)
        h.add(pt)
    }

    // upper hull
    var t = h.count + 1
    for (i in Stepped.descend(pts.count-2..0, 1)) {
        var pt = pts[i]
        while (h.count >= t && !ccw.call(h[-2], h[-1], pt)) h.removeAt(-1)
        h.add(pt)
    }

    h.removeAt(-1)
    return h
}

var pts = [
    Point.new(16,  3), Point.new(12, 17), Point.new( 0,  6), Point.new(-4, -6), Point.new(16,  6),
    Point.new(16, -7), Point.new(16, -3), Point.new(17, -4), Point.new( 5, 19), Point.new(19, -8),
    Point.new( 3, 16), Point.new(12, 13), Point.new( 3, -4), Point.new(17,  5), Point.new(-3, 15),
    Point.new(-3, -9), Point.new( 0, 11), Point.new(-9, -3), Point.new(-4, -2), Point.new(12, 10)
]
System.print("Convex Hull: %(convexHull.call(pts))")
