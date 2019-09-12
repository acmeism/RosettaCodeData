object PolynomialRegression extends App {
  private def xy = Seq(1, 6, 17, 34, 57, 86, 121, 162, 209, 262, 321).zipWithIndex.map(_.swap)

  private def polyRegression(xy: Seq[(Int, Int)]): Unit = {
    val r = xy.indices

    def average[U](ts: Iterable[U])(implicit num: Numeric[U]) = num.toDouble(ts.sum) / ts.size

    def x3m: Double = average(r.map(a => a * a * a))
    def x4m: Double = average(r.map(a => a * a * a * a))
    def x2ym = xy.reduce((a, x) => (a._1 + x._1 * x._1 * x._2, 0))._1.toDouble / xy.size
    def xym = xy.reduce((a, x) => (a._1 + x._1 * x._2, 0))._1.toDouble / xy.size

    val x2m: Double = average(r.map(a => a * a))
    val (xm, ym) = (average(xy.map(_._1)), average(xy.map(_._2)))
    val (sxx, sxy) = (x2m - xm * xm, xym - xm * ym)
    val sxx2: Double = x3m - xm * x2m
    val sx2x2: Double = x4m - x2m * x2m
    val sx2y: Double = x2ym - x2m * ym
    val c: Double = (sx2y * sxx - sxy * sxx2) / (sxx * sx2x2 - sxx2 * sxx2)
    val b: Double = (sxy * sx2x2 - sx2y * sxx2) / (sxx * sx2x2 - sxx2 * sxx2)
    val a: Double = ym - b * xm - c * x2m

    def abc(xx: Int) = a + b * xx + c * xx * xx

    println(s"y = $a + ${b}x + ${c}x^2")
    println(" Input  Approximation")
    println(" x   y     y1")
    xy.foreach {el => println(f"${el._1}%2d ${el._2}%3d  ${abc(el._1)}%5.1f")}
  }

  polyRegression(xy)

}
