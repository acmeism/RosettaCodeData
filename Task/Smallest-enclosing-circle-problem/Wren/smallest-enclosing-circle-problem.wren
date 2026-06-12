import "random" for Random

var Rand = Random.new()

class Point {
    // returns the square of the distance between two points
    static distSq(a, b) { (a.x - b.x)*(a.x - b.x) + (a.y - b.y)*(a.y - b.y) }

    // returns the center of a circle defined by 3 points
    static getCircleCenter(bx, by, cx, cy) {
        var b = bx*bx + by*by
        var c = cx*cx + cy*cy
        var d = bx*cy - by*cx
        return Point.new((cy*b - by*c) / (2 * d), (bx*c - cx*b) / (2 * d))
    }

    // constructs a new Point object
    construct new(x, y) {
        _x = x
        _y = y
    }

    // basic properties
    x { _x }
    x=(o) { _x = o }
    y { _y }
    y=(o) { _y = o }

    // returns a copy of the current instance
    copy() { Point.new(_x, _y) }

    // string representation
    toString { "(%(_x), %(_y))" }
}

class Circle {
    // returns a unique circle that intersects 3 points
    static from(a, b, c) {
        var i = Point.getCircleCenter(b.x - a.x, b.y - a.y, c.x - a.x, c.y - a.y)
        i.x = i.x + a.x
        i.y = i.y + a.y
        return Circle.new(i, Point.distSq(i, a).sqrt)
    }

    // returns smallest circle that intersects 2 points
    static from(a, b) {
        var c = Point.new((a.x + b.x) / 2, (a.y + b.y) / 2)
        return Circle.new(c, Point.distSq(a, b).sqrt/2)
    }

    // returns smallest enclosing circle for n <= 3
    static secTrivial(rs) {
        var size = rs.count
        if (size > 3) Fiber.abort("There shouldn't be more than 3 points.")
        if (size == 0) return Circle.new(Point.new(0, 0), 0)
        if (size == 1) return Circle.new(rs[0], 0)
        if (size == 2) return Circle.from(rs[0], rs[1])
        for (i in 0..1) {
            for (j in i+1..2) {
                var c = Circle.from(rs[i], rs[j])
                if (c.encloses(rs)) return c
            }
        }
        return Circle.from(rs[0], rs[1], rs[2])
    }

    // private helper method for Welzl method
    static welzl_(ps, rs, n) {
        rs = rs.toList // passed by value so need to copy
        if (n == 0 || rs.count == 3) return secTrivial(rs)
        var idx = Rand.int(n)
        var p = ps[idx]
        ps[idx] = ps[n-1]
        ps[n-1] = p
        var d = welzl_(ps, rs, n-1)
        if (d.contains(p)) return d
        rs.add(p)
        return welzl_(ps, rs, n-1)
    }

    // applies the Welzl algorithm to find the SEC
    static welzl(ps) {
        var pc = List.filled(ps.count, null)
        for (i in 0...pc.count) pc[i] = ps[i].copy()
        Rand.shuffle(pc)
        return welzl_(pc, [], pc.count)
    }

    // constructs a new Circle object from its center point and its radius
    construct new(c, r) {
        _c = c.copy()
        _r = r
    }

    // basic properties
    c { _c }
    r { _r }

    // returns whether the current instance contains the point 'p'
    contains(p) { Point.distSq(_c, p) <= _r * _r }

    // returns whether the current instance contains a list of points
    encloses(ps) {
        for (p in ps) if (!contains(p)) return false
        return true
    }

    // string representation
    toString { "Center %(_c), Radius %(_r)" }
}

var tests = [
    [Point.new(0, 0), Point.new(0, 1), Point.new(1, 0)],
    [Point.new(5, -2), Point.new(-3, -2), Point.new(-2, 5), Point.new(1, 6), Point.new(0, 2)]
]

for (test in tests) System.print(Circle.welzl(test))
