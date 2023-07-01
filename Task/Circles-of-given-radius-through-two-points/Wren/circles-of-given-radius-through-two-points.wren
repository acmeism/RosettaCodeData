import "/math" for Math

var Two  = "Two circles."
var R0   = "R == 0 does not describe circles."
var Co   = "Coincident points describe an infinite number of circles."
var CoR0 = "Coincident points with r == 0 describe a degenerate circle."
var Diam = "Points form a diameter and describe only a single circle."
var Far  = "Points too far apart to form circles."

class Point {
    construct new(x, y) {
        _x = x
        _y = y
    }

    x { _x }
    y { _y }
    ==(p) { _x == p.x && _y == p.y }

    toString { "(%(_x), %(_y))" }
}

var circles = Fn.new { |p1, p2, r|
    var c1 = Point.new(0, 0)
    var c2 = Point.new(0, 0)
    if (p1 == p2) {
        if (r == 0) return [p1, p1, CoR0]
        return [c1, c2, Co]
    }
    if (r == 0) return [p1, p2, R0]
    var dx = p2.x - p1.x
    var dy = p2.y - p1.y
    var q = Math.hypot(dx, dy)
    if (q > 2*r) return [c1, c2, Far]
    var m = Point.new((p1.x + p2.x)/2, (p1.y + p2.y)/2)
    if (q == 2*r) return [m, m, Diam]
    var d = (r*r - q*q/4).sqrt
    var ox = d * dx / q
    var oy = d * dy / q
    return [Point.new(m.x - oy, m.y + ox), Point.new(m.x + oy, m.y - ox), Two]
}

var td = [
    [Point.new(0.1234, 0.9876), Point.new(0.8765, 0.2345), 2.0],
    [Point.new(0.0000, 2.0000), Point.new(0.0000, 0.0000), 1.0],
    [Point.new(0.1234, 0.9876), Point.new(0.1234, 0.9876), 2.0],
    [Point.new(0.1234, 0.9876), Point.new(0.8765, 0.2345), 0.5],
    [Point.new(0.1234, 0.9876), Point.new(0.1234, 0.9876), 0.0]
]
for (tc in td) {
    System.print("p1: %(tc[0])")
    System.print("p2: %(tc[1])")
    System.print("r : %(tc[2])")
    var res = circles.call(tc[0], tc[1], tc[2])
    System.print("    %(res[2])")
    if (res[2] == CoR0 || res[2] == Diam) {
        System.print("    Center: %(res[0])")
    } else if (res[2] == Two) {
        System.print("    Center 1: %(res[0])")
        System.print("    Center 2: %(res[1])")
    }
    System.print()
}
