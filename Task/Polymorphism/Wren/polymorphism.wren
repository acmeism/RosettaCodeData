class Point {
    construct new(x, y) {
        _x = x
        _y = y
    }

    static new(x) { new(x, 0) }
    static new()  { new(0, 0) }

    static fromPoint(p) { new(p.x, p.y) }

    x { _x }
    y { _y }

    print() { System.print("Point at (%(_x), %(_y))") }
}

class Circle is Point {
    construct new(x, y, r) {
        super(x, y)
        _r = r
    }

    static new(x, r) { new(x, 0, r) }
    static new(x)    { new(x, 0, 0) }
    static new()     { new(0, 0, 0) }

    static fromCircle(c) { new(c.x, c.y, c.r) }

    r { _r }

    print() { System.print("Circle at center(%(x), %(y)), radius %(_r)") }
}

var points = [Point.new(), Point.new(1), Point.new(2, 3), Point.fromPoint(Point.new(3, 4))]
for (point in points) point.print()
var circles = [
    Circle.new(), Circle.new(1), Circle.new(2, 3),
    Circle.new(4, 5, 6), Circle.fromCircle(Circle.new(7, 8, 9))
]
for (circle in circles) circle.print()
