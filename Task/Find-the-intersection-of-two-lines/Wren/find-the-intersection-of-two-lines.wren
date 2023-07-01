class Point {
    construct new(x, y) {
        _x = x
        _y = y
    }

    x { _x }
    y { _y }

    toString { "(%(_x), %(_y))" }
}

class Line {
    construct new(s, e) {
        _s = s
        _e = e
    }

    s { _s }
    e { _e }
}

var findIntersection = Fn.new { |l1, l2|
    var a1 = l1.e.y - l1.s.y
    var b1 = l1.s.x - l1.e.x
    var c1 = a1*l1.s.x + b1*l1.s.y

    var a2 = l2.e.y - l2.s.y
    var b2 = l2.s.x - l2.e.x
    var c2 = a2*l2.s.x + b2*l2.s.y

    var delta = a1*b2 - a2*b1
    // if lines are parallel, intersection point will contain infinite values
    return Point.new((b2*c1 - b1*c2)/delta, (a1*c2 - a2*c1)/delta)
}

var l1 = Line.new(Point.new(4, 0), Point.new(6, 10))
var l2 = Line.new(Point.new(0, 3), Point.new(10, 7))
System.print(findIntersection.call(l1, l2))
l1 = Line.new(Point.new(0, 0), Point.new(1, 1))
l2 = Line.new(Point.new(1, 2), Point.new(4, 5))
System.print(findIntersection.call(l1, l2))
