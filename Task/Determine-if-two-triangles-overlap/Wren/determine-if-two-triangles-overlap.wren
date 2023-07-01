import "/dynamic" for Tuple, Struct

var Point = Tuple.create("Point", ["x", "y"])

var Triangle = Struct.create("Triangle", ["p1", "p2", "p3"])

var det2D = Fn.new { |t|
    return t.p1.x * (t.p2.y - t.p3.y) +
           t.p2.x * (t.p3.y - t.p1.y) +
           t.p3.x * (t.p1.y - t.p2.y)
}

var checkTriWinding = Fn.new { |t, allowReversed|
    var detTri = det2D.call(t)
    if (detTri < 0) {
        if (allowReversed) {
           var a = t.p3
	       t.p3  = t.p2
	       t.p2 =  a
        } else Fiber.abort("Triangle has wrong winding direction")
    }
}

var boundaryCollideChk = Fn.new { |t, eps| det2D.call(t) < eps }

var boundaryDoesntCollideChk = Fn.new { |t, eps| det2D.call(t) <= eps }

var triTri2D = Fn.new { |t1, t2, eps, allowReversed, onBoundary|
    // Triangles must be expressed anti-clockwise
    checkTriWinding.call(t1, allowReversed)
    checkTriWinding.call(t2, allowReversed)
    // 'onBoundary' determines whether points on boundary are considered as colliding or not
    var chkEdge = onBoundary ? boundaryCollideChk : boundaryDoesntCollideChk
    var lp1 = [t1.p1, t1.p2, t1.p3]
    var lp2 = [t2.p1, t2.p2, t2.p3]

    // for each edge E of t1
    for (i in 0..2) {
        var j = (i + 1) % 3
        // Check all points of t2 lay on the external side of edge E.
        // If they do, the triangles do not overlap.
	    if (chkEdge.call(Triangle.new(lp1[i], lp1[j], lp2[0]), eps) &&
            chkEdge.call(Triangle.new(lp1[i], lp1[j], lp2[1]), eps) &&
            chkEdge.call(Triangle.new(lp1[i], lp1[j], lp2[2]), eps)) return false
    }

    // for each edge E of t2
    for (i in 0..2) {
        var j = (i + 1) % 3
        // Check all points of t1 lay on the external side of edge E.
        // If they do, the triangles do not overlap.
        if (chkEdge.call(Triangle.new(lp2[i], lp2[j], lp1[0]), eps) &&
            chkEdge.call(Triangle.new(lp2[i], lp2[j], lp1[1]), eps) &&
            chkEdge.call(Triangle.new(lp2[i], lp2[j], lp1[2]), eps)) return false
    }

    // The triangles overlap
    return true
}

var tr = "Triangle: "
var printTris = Fn.new { |t1, t2, nl| System.print("%(nl)%(tr)%(t1) and\n%(tr)%(t2)") }

var t1 = Triangle.new(Point.new(0, 0), Point.new(5, 0), Point.new(0, 5))
var t2 = Triangle.new(Point.new(0, 0), Point.new(5, 0), Point.new(0, 6))
printTris.call(t1, t2, "")
System.print(triTri2D.call(t1, t2, 0, false, true) ? "overlap" : "do not overlap")

// need to allow reversed for this pair to avoid exception
t1 = Triangle.new(Point.new(0, 0), Point.new(0, 5), Point.new(5, 0))
t2 = t1
printTris.call(t1, t2, "\n")
System.print(triTri2D.call(t1, t2, 0, true, true) ? "overlap (reversed)" : "do not overlap")

t1 = Triangle.new(Point.new(0, 0), Point.new(5, 0), Point.new(0, 5))
t2 = Triangle.new(Point.new(-10, 0), Point.new(-5, 0), Point.new(-1, 6))
printTris.call(t1, t2, "\n")
System.print(triTri2D.call(t1, t2, 0, false, true) ? "overlap" : "do not overlap")

t1.p3 = Point.new(2.5, 5)
t2 = Triangle.new(Point.new(0, 4), Point.new(2.5, -1), Point.new(5, 4))
printTris.call(t1, t2, "\n")
System.print(triTri2D.call(t1, t2, 0, false, true) ? "overlap" : "do not overlap")

t1 = Triangle.new(Point.new(0, 0), Point.new(1, 1), Point.new(0, 2))
t2 = Triangle.new(Point.new(2, 1), Point.new(3, 0), Point.new(3, 2))
printTris.call(t1, t2, "\n")
System.print(triTri2D.call(t1, t2, 0, false, true) ? "overlap" : "do not overlap")

t2 = Triangle.new(Point.new(2, 1), Point.new(3, -2), Point.new(3, 4))
printTris.call(t1, t2, "\n")
System.print(triTri2D.call(t1, t2, 0, false, true) ? "overlap" : "do not overlap")

t1 = Triangle.new(Point.new(0, 0), Point.new(1, 0), Point.new(0, 1))
t2 = Triangle.new(Point.new(1, 0), Point.new(2, 0), Point.new(1, 1.1))
printTris.call(t1, t2, "\n")
System.print("which have only a single corner in contact, if boundary points collide")
System.print(triTri2D.call(t1, t2, 0, false, true) ? "overlap" : "do not overlap")

printTris.call(t1, t2, "\n")
System.print("which have only a single corner in contact, if boundary points do not collide")
System.print(triTri2D.call(t1, t2, 0, false, false) ? "overlap" : "do not overlap")
