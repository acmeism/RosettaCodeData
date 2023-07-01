object Overlap {
  type Point = (Double, Double)

  class Triangle(var p1: Point, var p2: Point, var p3: Point) {
    override def toString: String = s"Triangle: $p1, $p2, $p3"
  }

  def det2D(t: Triangle): Double = {
    val (p1, p2, p3) = (t.p1, t.p2, t.p3)
    p1._1 * (p2._2 - p3._2) +
      p2._1 * (p3._2 - p1._2) +
      p3._1 * (p1._2 - p2._2)
  }

  def checkTriWinding(t: Triangle, allowReversed: Boolean): Unit = {
    val detTri = det2D(t)
    if (detTri < 0.0) {
      if (allowReversed) {
        val a = t.p3
        t.p3 = t.p2
        t.p2 = a
      } else throw new RuntimeException("Triangle has wrong winding direction")
    }
  }

  def boundaryCollideChk(t: Triangle, eps: Double): Boolean = det2D(t) < eps

  def boundaryDoesntCollideChk(t: Triangle, eps: Double): Boolean = det2D(t) <= eps

  def triTri2D(t1: Triangle, t2: Triangle, eps: Double = 0.0, allowReversed: Boolean = false, onBoundary: Boolean = true): Boolean = {
    //triangles must be expressed anti-clockwise
    checkTriWinding(t1, allowReversed)
    checkTriWinding(t2, allowReversed)
    // 'onBoundary' determines whether points on boundary are considered as colliding or not
    val chkEdge = if (onBoundary) Overlap.boundaryCollideChk _ else Overlap.boundaryDoesntCollideChk _
    val lp1 = Array(t1.p1, t1.p2, t1.p3)
    val lp2 = Array(t2.p1, t2.p2, t2.p3)

    // for each edge E of t1
    for (i <- 0 until 3) {
      val j = (i + 1) % 3
      // Check all points of t2 lay on the external side of edge E.
      // If they do, the triangles do not overlap.
      if (chkEdge(new Triangle(lp1(i), lp1(j), lp2(0)), eps)
        && chkEdge(new Triangle(lp1(i), lp1(j), lp2(1)), eps)
        && chkEdge(new Triangle(lp1(i), lp1(j), lp2(2)), eps)) return false
    }

    // for each edge E of t2
    for (i <- 0 until 3) {
      val j = (i + 1) % 3
      // Check all points of t1 lay on the external side of edge E.
      // If they do, the triangles do not overlap.
      if (chkEdge(new Triangle(lp2(i), lp2(j), lp1(0)), eps)
        && chkEdge(new Triangle(lp2(i), lp2(j), lp1(1)), eps)
        && chkEdge(new Triangle(lp2(i), lp2(j), lp1(2)), eps)) return false
    }

    // The triangles overlap
    true
  }

  def main(args: Array[String]): Unit = {
    var t1 = new Triangle((0.0, 0.0), (5.0, 0.0), (0.0, 5.0))
    var t2 = new Triangle((0.0, 0.0), (5.0, 0.0), (0.0, 6.0))
    println(s"$t1 and\n$t2")
    println(if (triTri2D(t1, t2)) "overlap" else "do not overlap")

    // need to allow reversed for this pair to avoid exception
    t1 = new Triangle((0.0, 0.0), (0.0, 5.0), (5.0, 0.0))
    t2 = t1
    println(s"\n$t1 and\n$t2")
    println(if (triTri2D(t1, t2, 0.0, allowReversed = true)) "overlap (reversed)" else "do not overlap")

    t1 = new Triangle((0.0, 0.0), (5.0, 0.0), (0.0, 5.0))
    t2 = new Triangle((-10.0, 0.0), (-5.0, 0.0), (-1.0, 6.0))
    println(s"\n$t1 and\n$t2")
    println(if (triTri2D(t1, t2)) "overlap" else "do not overlap")

    t1.p3 = (2.5, 5.0)
    t2 = new Triangle((0.0, 4.0), (2.5, -1.0), (5.0, 4.0))
    println(s"\n$t1 and\n$t2")
    println(if (triTri2D(t1, t2)) "overlap" else "do not overlap")

    t1 = new Triangle((0.0, 0.0), (1.0, 1.0), (0.0, 2.0))
    t2 = new Triangle((2.0, 1.0), (3.0, 0.0), (3.0, 2.0))
    println(s"\n$t1 and\n$t2")
    println(if (triTri2D(t1, t2)) "overlap" else "do not overlap")

    t2 = new Triangle((2.0, 1.0), (3.0, -2.0), (3.0, 4.0))
    println(s"\n$t1 and\n$t2")
    println(if (triTri2D(t1, t2)) "overlap" else "do not overlap")

    t1 = new Triangle((0.0, 0.0), (1.0, 0.0), (0.0, 1.0))
    t2 = new Triangle((1.0, 0.0), (2.0, 0.0), (1.0, 1.1))
    println(s"\n$t1 and\n$t2")
    println("which have only a single corner in contact, if boundary points collide")
    println(if (triTri2D(t1, t2)) "overlap" else "do not overlap")

    println(s"\n$t1 and\n$t2")
    println("which have only a single corner in contact, if boundary points do not collide")
    println(if (triTri2D(t1, t2, onBoundary = false)) "overlap" else "do not overlap")
  }
}
