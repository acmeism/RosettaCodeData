/* The control points of a planar quadratic Bézier curve form a
   triangle--called the "control polygon"--that completely contains
   the curve. Furthermore, the rectangle formed by the minimum and
   maximum x and y values of the control polygon completely contain
   the polygon, and therefore also the curve.

   Thus a simple method for narrowing down where intersections might
   be is: subdivide both curves until you find "small enough" regions
   where these rectangles overlap.
*/

import "./dynamic" for Struct
import "./trait" for ByRef
import "./math" for Math, Nums
import "./assert" for Assert
import "./seq" for Stack
import "./fmt" for Fmt

// Note that these are all mutable as we need to pass by reference.
var Point      = Struct.create("Point", ["x", "y"])
var QuadSpline = Struct.create("QuadSpline", ["c0", "c1", "c2"]) // non-parametric
var QuadCurve  = Struct.create("QuadCurve", ["x", "y"]) // planar parametric
var Workset    = Struct.create("Workset", ["p", "q"])

// Subdivision by de Casteljau's algorithm
var subdivideQuadSpline = Fn.new { |q, t, u, v|
    var s = 1 - t
    var c0 = q.c0
    var c1 = q.c1
    var c2 = q.c2
    u.c0 = c0
    v.c2 = c2
    u.c1 = s * c0 + t * c1
    v.c1 = s * c1 + t * c2
    u.c2 = s * u.c1 + t * v.c1
    v.c0 = u.c2
}

var subdivideQuadCurve = Fn.new { |q, t, u, v|
    subdivideQuadSpline.call(q.x, t, u.x, v.x)
    subdivideQuadSpline.call(q.y, t, u.y, v.y)
}

// It is assumed that xa0 <= xa1, ya0 <= ya1, xb0 <= xb1, and yb0 <= yb1.
var rectsOverlap = Fn.new { |xa0, ya0, xa1, ya1, xb0, yb0, xb1, yb1|
    return (xb0 <= xa1 && xa0 <= xb1 && yb0 <= ya1 && ya0 <= yb1)
}

// This accepts the point as an intersection if the boxes are small enough.
var testIntersect = Fn.new { |p, q, tol, exclude, accept, intersect|
    var pxmin = Nums.min([p.x.c0, p.x.c1, p.x.c2])
    var pymin = Nums.min([p.y.c0, p.y.c1, p.y.c2])
    var pxmax = Nums.max([p.x.c0, p.x.c1, p.x.c2])
    var pymax = Nums.max([p.y.c0, p.y.c1, p.y.c2])

    var qxmin = Nums.min([q.x.c0, q.x.c1, q.x.c2])
    var qymin = Nums.min([q.y.c0, q.y.c1, q.y.c2])
    var qxmax = Nums.max([q.x.c0, q.x.c1, q.x.c2])
    var qymax = Nums.max([q.y.c0, q.y.c1, q.y.c2])

    exclude.value = true
    accept.value = false
    if (rectsOverlap.call(pxmin, pymin, pxmax, pymax, qxmin, qymin, qxmax, qymax)) {
        exclude.value = false
        var xmin = Math.max(pxmin, qxmin)
        var xmax = Math.min(pxmax, qxmax)
        Assert.ok(xmax >= xmin)
        if (xmax - xmin <= tol) {
            var ymin = Math.max(pymin, qymin)
            var ymax = Math.min(pymax, qymax)
            Assert.ok(ymax >= ymin)
            if (ymax - ymin <= tol) {
                accept.value = true
                intersect.x = 0.5 * xmin + 0.5 * xmax
                intersect.y = 0.5 * ymin + 0.5 * ymax
            }
        }
    }
}

var seemsToBeDuplicate = Fn.new { |intersects, xy, spacing|
    var seemsToBeDup = false
    var i = 0
    while (!seemsToBeDup && i != intersects.count) {
        var pt = intersects[i]
        seemsToBeDup = (pt.x - xy.x).abs < spacing && (pt.y - xy.y).abs < spacing
        i = i + 1
    }
    return seemsToBeDup
}

var findIntersects = Fn.new { |p, q, tol, spacing|
    var intersects = []
    var workload = Stack.new()
    workload.push(Workset.new(p, q))

    // Quit looking after having emptied the workload.
    while (!workload.isEmpty) {
        var work = workload.peek()
        workload.pop()
        var exclude = ByRef.new(false)
        var accept  = ByRef.new(false)
        var intersect = Point.new(0, 0)
        testIntersect.call(work.p, work.q, tol, exclude, accept, intersect)
        if (accept.value) {
            // To avoid detecting the same intersection twice, require some
            // space between intersections.
            if (!seemsToBeDuplicate.call(intersects, intersect, spacing)) {
                intersects.add(intersect)
            }
        } else if (!exclude.value) {
            var p0 = QuadCurve.new(QuadSpline.new(0, 0, 0), QuadSpline.new(0, 0, 0))
            var p1 = QuadCurve.new(QuadSpline.new(0, 0, 0), QuadSpline.new(0, 0, 0))
            var q0 = QuadCurve.new(QuadSpline.new(0, 0, 0), QuadSpline.new(0, 0, 0))
            var q1 = QuadCurve.new(QuadSpline.new(0, 0, 0), QuadSpline.new(0, 0, 0))
            subdivideQuadCurve.call(work.p, 0.5, p0, p1)
            subdivideQuadCurve.call(work.q, 0.5, q0, q1)
            workload.push(Workset.new(p0, q0))
            workload.push(Workset.new(p0, q1))
            workload.push(Workset.new(p1, q0))
            workload.push(Workset.new(p1, q1))
        }
    }
    return intersects
}

var p = QuadCurve.new(QuadSpline.new(-1,  0, 1), QuadSpline.new(0, 10, 0))
var q = QuadCurve.new(QuadSpline.new( 2, -8, 2), QuadSpline.new(1,  2, 3))
var tol = 0.0000001
var spacing = 10 * tol
var intersects = findIntersects.call(p, q, tol, spacing)
for (intersect in intersects) Fmt.print("($ f, $f)", intersect.x, intersect.y)
