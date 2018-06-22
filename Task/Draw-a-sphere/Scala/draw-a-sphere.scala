object Sphere extends App {
  private val (shades, light) = (Seq('.', ':', '!', '*', 'o', 'e', '&', '#', '%', '@'), Array(30d, 30d, -50d))

  private def drawSphere(r: Double, k: Double, ambient: Double): Unit = {
    def dot(x: Array[Double], y: Array[Double]) = {
      val d = x.head * y.head + x(1) * y(1) + x.last * y.last
      if (d < 0) -d else 0D
    }

    for (i <- math.floor(-r).toInt to math.ceil(r).toInt; x = i + .5)
      println(
        (for (j <- math.floor(-2 * r).toInt to math.ceil(2 * r).toInt; y = j / 2.0 + .5)
          yield if (x * x + y * y <= r * r) {

            def intensity(vec: Array[Double]) = {
              val b = math.pow(dot(light, vec), k) + ambient
              if (b <= 0) shades.length - 2
              else math.max((1 - b) * (shades.length - 1), 0).toInt
            }

            shades(intensity(normalize(Array(x, y, scala.math.sqrt(r * r - x * x - y * y)))))
          } else ' ').mkString)
  }

  private def normalize(v: Array[Double]): Array[Double] = {
    val len = math.sqrt(v.head * v.head + v(1) * v(1) + v.last * v.last)
    v.map(_ / len)
  }

  normalize(light).copyToArray(light)
  drawSphere(20, 4, .1)
  drawSphere(10, 2, .4)

}
