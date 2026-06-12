import "./trait" for Comparable
import "./math" for Nums
import "./sort" for Sort, Cmp
import "./seq" for Lst
import "io" for Stdout

class Point is Comparable {
    construct new(x, y) {
        _x = x
        _y = y
    }

    x { _x }
    y { _y }

    rotate90()  { Point.new( _y, -_x) }
    rotate180() { Point.new(-_x, -_y) }
    rotate270() { Point.new(-_y,  _x) }
    reflect()   { Point.new(-_x,  _y) }

    compare(other) {
        if (other.type != Point) Fiber.abort("Argument must be a point.")
        if (_x == other.x && _y == other.y) return 0
        if (_x < other.x || (_x == other.x && _y < other.y)) return -1
        return 1
    }

    // All four points in Von Neumann neighborhood
    contiguous {
        return [
            Point.new(_x - 1, _y), Point.new(_x + 1, _y),
            Point.new(_x, _y - 1), Point.new(_x, _y + 1)
        ]
    }

    toString { "(%(x), %(y))" }
}

var DistinctByString = Fn.new { |list|
    var m = {}
    for (e in list) m[e.toString] = e
    return m.keys.map { |key| m[key] }.toList
}

class Polyomino {
    construct new(points) {
        _points = points
    }

    points { _points }

    // Finds the min x and y coordinates of a Polyomino.
    minima {
        var minX = Nums.min(_points.map { |p| p.x })
        var minY = Nums.min(_points.map { |p| p.y })
        return [minX, minY]
    }

    translateToOrigin() {
        var mins = minima
        var points = _points.map { |p| Point.new(p.x - mins[0], p.y - mins[1]) }.toList
        Sort.quick(points)
        return Polyomino.new(points)
    }

    // All the plane symmetries of a rectangular region.
    rotationsAndReflections {
        return [
            Polyomino.new(_points),
            Polyomino.new(_points.map { |p| p.rotate90()  }.toList),
            Polyomino.new(_points.map { |p| p.rotate180() }.toList),
            Polyomino.new(_points.map { |p| p.rotate270() }.toList),
            Polyomino.new(_points.map { |p| p.reflect()   }.toList),
            Polyomino.new(_points.map { |p| p.rotate90().reflect()  }.toList),
            Polyomino.new(_points.map { |p| p.rotate180().reflect() }.toList),
            Polyomino.new(_points.map { |p| p.rotate270().reflect() }.toList)
        ]
    }

    canonical {
        var toos = rotationsAndReflections.map { |poly| poly.translateToOrigin() }.toList
        var cmp = Fn.new { |i, j| Cmp.string.call(i.toString, j.toString) }
        Sort.quick(toos, 0, toos.count - 1, cmp)
        return toos[0]
    }

    // Finds all distinct points that can be added to a Polyomino.
    newPoints {
        var fn = Fn.new { |p| p.contiguous }
        var t = Lst.flatMap(_points, fn).where { |p| !_points.contains(p) }.toList
        return DistinctByString.call(t)
    }

    newPolys { newPoints.map { |p| Polyomino.new(_points + [p]).canonical }.toList }

    toString { _points.map { |p| p.toString }.join(" ") }
}

var monomino = Polyomino.new([Point.new(0, 0)])
var monominoes = [monomino]

// Generates polyominoes of rank n recursively.
var rank
rank = Fn.new { |n|
    if (n < 0) Fiber.abort("n cannot be negative.")
    if (n == 0) return []
    if (n == 1) return monominoes
    var t = Lst.flatMap(rank.call(n-1)) { |poly| poly.newPolys }.toList
    t = DistinctByString.call(t)
    var cmp = Fn.new { |i, j| Cmp.string.call(i.toString, j.toString) }
    Sort.quick(t, 0, t.count - 1, cmp)
    return t
}

var n = 5
System.print("All free polyominoes of rank %(n):\n")
for (poly in rank.call(n)) {
    for (pt in poly.points) System.write("%(pt) ")
    System.print()
}
var k = 10
System.print("\nNumber of free polyominoes of ranks 1 to %(k):")
for (i in 1..k) {
    System.write("%(rank.call(i).count) ")
    Stdout.flush()
}
System.print()
