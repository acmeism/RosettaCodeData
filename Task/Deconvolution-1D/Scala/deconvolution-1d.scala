object Deconvolution1D extends App {
  val (h, f) = (Array(-8, -9, -3, -1, -6, 7), Array(-3, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1))
  val g = Array(24, 75, 71, -34, 3, 22, -45, 23, 245, 25, 52, 25, -67, -96, 96, 31, 55, 36, 29, -43, -7)
  val sb = new StringBuilder

  private def deconv(g: Array[Int], f: Array[Int]) = {
    val h = Array.ofDim[Int](g.length - f.length + 1)

    for (n <- h.indices) {
      h(n) = g(n)
      for (i <- math.max(n - f.length + 1, 0) until n) h(n) -= h(i) * f(n - i)
      h(n) /= f(0)
    }
    h
  }

  sb.append(s"h = ${h.mkString("[", ", ", "]")}\n")
    .append(s"deconv(g, f) = ${deconv(g, f).mkString("[", ", ", "]")}\n")
    .append(s"f = ${f.mkString("[", ", ", "]")}\n")
    .append(s"deconv(g, h) = ${deconv(g, h).mkString("[", ", ", "]")}")
  println(sb.result())

}
