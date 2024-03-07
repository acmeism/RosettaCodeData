object Steffensen {

  def aitken(p0: Double): Double = {
    val p1 = f(p0)
    val p2 = f(p1)
    val p1m0 = p1 - p0
    p0 - p1m0 * p1m0 / (p2 - 2.0 * p1 + p0)
  }

  def steffensenAitken(pinit: Double, tol: Double, maxiter: Int): Option[Double] = {
    var p0 = pinit
    var p = aitken(p0)
    var iter = 1
    while (math.abs(p - p0) > tol && iter < maxiter) {
      p0 = p
      p = aitken(p0)
      iter += 1
    }
    if (math.abs(p - p0) > tol) None else Some(p)
  }

  def deCasteljau(c0: Double, c1: Double, c2: Double, t: Double): Double = {
    val s = 1.0 - t
    val c01 = s * c0 + t * c1
    val c12 = s * c1 + t * c2
    s * c01 + t * c12
  }

  def xConvexLeftParabola(t: Double): Double = deCasteljau(2.0, -8.0, 2.0, t)

  def yConvexRightParabola(t: Double): Double = deCasteljau(1.0, 2.0, 3.0, t)

  def implicitEquation(x: Double, y: Double): Double = 5.0 * x * x + y - 5.0

  def f(t: Double): Double = {
    val x = xConvexLeftParabola(t)
    val y = yConvexRightParabola(t)
    implicitEquation(x, y) + t
  }

  def main(args: Array[String]): Unit = {
    var t0 = 0.0
    for (i <- 0 until 11) {
      print(f"t0 = $t0%3.1f : ")
      steffensenAitken(t0, 0.00000001, 1000) match {
        case None => println("no answer")
        case Some(t) =>
          val x = xConvexLeftParabola(t)
          val y = yConvexRightParabola(t)
          if (math.abs(implicitEquation(x, y)) <= 0.000001) {
            println(f"intersection at ($x%f, $y%f)")
          } else {
            println("spurious solution")
          }
      }
      t0 += 0.1
    }
  }
}
