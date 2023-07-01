import "/dynamic" for Tuple

var Point = Tuple.create("Point", ["x", "y"])

var rdp // recursive
rdp = Fn.new { |l, eps|
    var x = 0
    var dMax = -1
    var p1 = l[0]
    var p2 = l[-1]
    var x21 = p2.x - p1.x
    var y21 = p2.y - p1.y
    var i = 0
    for (p in l[1..-1]) {
        var d = (y21*p.x - x21*p.y + p2.x*p1.y - p2.y*p1.x).abs
        if (d > dMax) {
            x = i + 1
            dMax = d
        }
        i = i + 1
    }
    if (dMax > eps) {
        return rdp.call(l[0..x], eps) + rdp.call(l[x..-1], eps)[1..-1]
    }
    return [l[0], l[-1]]
}

var points = [
    Point.new(0, 0), Point.new(1, 0.1), Point.new(2, -0.1), Point.new(3, 5), Point.new(4, 6),
    Point.new(5, 7), Point.new(6, 8.1), Point.new(7, 9), Point.new(8, 9), Point.new(9, 9)
]
System.print(rdp.call(points, 1))
