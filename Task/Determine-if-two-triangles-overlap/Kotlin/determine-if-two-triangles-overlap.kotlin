// version 1.1.0

typealias Point = Pair<Double, Double>

data class Triangle(var p1: Point, var p2: Point, var p3: Point) {
    override fun toString() = "Triangle: $p1, $p2, $p3"
}

fun det2D(t: Triangle): Double {
    val (p1, p2, p3) = t
    return  p1.first * (p2.second - p3.second) +
            p2.first * (p3.second - p1.second) +
            p3.first * (p1.second - p2.second)
}

fun checkTriWinding(t: Triangle, allowReversed: Boolean) {
    val detTri = det2D(t)
    if (detTri < 0.0) {
        if (allowReversed) {
           val a = t.p3
	   t.p3  = t.p2
	   t.p2 =  a
        }
        else throw RuntimeException("Triangle has wrong winding direction")
    }
}

fun boundaryCollideChk(t: Triangle, eps: Double) = det2D(t) < eps

fun boundaryDoesntCollideChk(t: Triangle, eps: Double) = det2D(t) <= eps

fun triTri2D(t1: Triangle, t2: Triangle, eps: Double = 0.0,
             allowReversed: Boolean = false, onBoundary: Boolean = true): Boolean {
    // Triangles must be expressed anti-clockwise
    checkTriWinding(t1, allowReversed)
    checkTriWinding(t2, allowReversed)
    // 'onBoundary' determines whether points on boundary are considered as colliding or not
    val chkEdge = if (onBoundary) ::boundaryCollideChk else ::boundaryDoesntCollideChk
    val lp1 = listOf(t1.p1, t1.p2, t1.p3)
    val lp2 = listOf(t2.p1, t2.p2, t2.p3)

    // for each edge E of t1
    for (i in 0 until 3) {
        val j = (i + 1) % 3
        // Check all points of t2 lay on the external side of edge E.
        // If they do, the triangles do not overlap.
	if (chkEdge(Triangle(lp1[i], lp1[j], lp2[0]), eps) &&
            chkEdge(Triangle(lp1[i], lp1[j], lp2[1]), eps) &&
            chkEdge(Triangle(lp1[i], lp1[j], lp2[2]), eps)) return false
    }

    // for each edge E of t2
    for (i in 0 until 3) {
        val j = (i + 1) % 3
        // Check all points of t1 lay on the external side of edge E.
        // If they do, the triangles do not overlap.
        if (chkEdge(Triangle(lp2[i], lp2[j], lp1[0]), eps) &&
            chkEdge(Triangle(lp2[i], lp2[j], lp1[1]), eps) &&
            chkEdge(Triangle(lp2[i], lp2[j], lp1[2]), eps)) return false
    }

    // The triangles overlap
    return true
}

fun main(args: Array<String>) {
    var t1 = Triangle(0.0 to 0.0, 5.0 to 0.0, 0.0 to 5.0)
    var t2 = Triangle(0.0 to 0.0, 5.0 to 0.0, 0.0 to 6.0)
    println("$t1 and\n$t2")
    println(if (triTri2D(t1, t2)) "overlap" else "do not overlap")

    // need to allow reversed for this pair to avoid exception
    t1 = Triangle(0.0 to 0.0, 0.0 to 5.0, 5.0 to 0.0)
    t2 = t1
    println("\n$t1 and\n$t2")
    println(if (triTri2D(t1, t2, 0.0, true)) "overlap (reversed)" else "do not overlap")

    t1 = Triangle(0.0 to 0.0, 5.0 to 0.0, 0.0 to 5.0)
    t2 = Triangle(-10.0 to 0.0, -5.0 to 0.0, -1.0 to 6.0)
    println("\n$t1 and\n$t2")
    println(if (triTri2D(t1, t2)) "overlap" else "do not overlap")

    t1.p3 = 2.5 to 5.0
    t2 = Triangle(0.0 to 4.0, 2.5 to -1.0, 5.0 to 4.0)
    println("\n$t1 and\n$t2")
    println(if (triTri2D(t1, t2)) "overlap" else "do not overlap")

    t1 = Triangle(0.0 to 0.0, 1.0 to 1.0, 0.0 to 2.0)
    t2 = Triangle(2.0 to 1.0, 3.0 to 0.0, 3.0 to 2.0)
    println("\n$t1 and\n$t2")
    println(if (triTri2D(t1, t2)) "overlap" else "do not overlap")

    t2 = Triangle(2.0 to 1.0, 3.0 to -2.0, 3.0 to 4.0)
    println("\n$t1 and\n$t2")
    println(if (triTri2D(t1, t2)) "overlap" else "do not overlap")

    t1 = Triangle(0.0 to 0.0, 1.0 to 0.0, 0.0 to 1.0)
    t2 = Triangle(1.0 to 0.0, 2.0 to 0.0, 1.0 to 1.1)
    println("\n$t1 and\n$t2")
    println("which have only a single corner in contact, if boundary points collide")
    println(if (triTri2D(t1, t2)) "overlap" else "do not overlap")

    println("\n$t1 and\n$t2")
    println("which have only a single corner in contact, if boundary points do not collide")
    println(if (triTri2D(t1, t2, 0.0, false, false)) "overlap" else "do not overlap")
}
