import "./dynamic" for Tuple
import "./math" for Math
import "./fmt" for Fmt

var Point = Tuple.create("Point", ["x", "y"])

// Add two polynomials.
var add = Fn.new { |p1, p2|
    var m = p1.count
    var n = p2.count
    var sum = List.filled(m.max(n), 0)
    for (i in 0...m) sum[i] = p1[i]
    for (i in 0...n) sum[i] = sum[i] + p2[i]
    return sum
}

// Multiply two polynmials.
var multiply = Fn.new { |p1, p2|
    var m = p1.count
    var n = p2.count
    var prod = List.filled(m + n - 1, 0)
    for (i in 0...m) {
        for (j in 0...n) prod[i+j] = prod[i+j] + p1[i] * p2[j]
    }
    return prod
}

// Multiply a polynomial by a scalar.
var scalarMultiply = Fn.new { |poly, x| poly.map { |coef| coef * x }.toList }

// Divide a polynomial by a scalar.
var scalarDivide = Fn.new { |poly, x| scalarMultiply.call(poly, 1/x) }

// Returns the Lagrange interpolating polynomial which passes through a list of points.
var lagrange = Fn.new { |pts|
    var c = pts.count
    var polys = List.filled(c, null)
    for (i in 0...c) {
        var poly = [1]
        for (j in 0...c) {
            if (i == j) continue
            poly = multiply.call(poly, [-pts[j].x, 1])
        }
        var d = Math.evalPoly(poly[-1..0], pts[i].x)
        polys[i] = scalarDivide.call(poly, d)
    }
    var sum = [0]
    for (i in 0...c) {
        polys[i] = scalarMultiply.call(polys[i], pts[i].y)
        sum = add.call(sum, polys[i])
    }
    return sum
}

var pts = [
    Point.new(1, 1),
    Point.new(2, 4),
    Point.new(3, 1),
    Point.new(4, 5)
]
var lip = lagrange.call(pts)
Fmt.pprint("$f", lip[-1..0], "", "x")
