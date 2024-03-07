object GaussianElimination {
  def solve(a: Array[Array[Double]], b: Array[Array[Double]]): Double = {
    if (a == null || b == null || a.length == 0 || b.length == 0) {
      throw new IllegalArgumentException("Invalid dimensions")
    }

    val n = b.length
    val p = b(0).length

    if (a.length != n || a(0).length != n) {
      throw new IllegalArgumentException("Invalid dimensions")
    }

    var det = 1.0

    for (i <- 0 until n - 1) {
      var k = i

      for (j <- i + 1 until n) {
        if (Math.abs(a(j)(i)) > Math.abs(a(k)(i))) {
          k = j
        }
      }

      if (k != i) {
        det = -det

        for (j <- i until n) {
          val s = a(i)(j)
          a(i)(j) = a(k)(j)
          a(k)(j) = s
        }

        for (j <- 0 until p) {
          val s = b(i)(j)
          b(i)(j) = b(k)(j)
          b(k)(j) = s
        }
      }

      for (j <- i + 1 until n) {
        val s = a(j)(i) / a(i)(i)

        for (k <- i + 1 until n) {
          a(j)(k) -= s * a(i)(k)
        }

        for (k <- 0 until p) {
          b(j)(k) -= s * b(i)(k)
        }
      }
    }

    for (i <- n - 1 to 0 by -1) {
      for (j <- i + 1 until n) {
        val s = a(i)(j)

        for (k <- 0 until p) {
          b(i)(k) -= s * b(j)(k)
        }
      }

      val s = a(i)(i)
      det *= s

      for (k <- 0 until p) {
        b(i)(k) /= s
      }
    }

    det
  }

  def main(args: Array[String]): Unit = {
    val a = Array(
      Array(4.0, 1.0, 0.0, 0.0, 0.0),
      Array(1.0, 4.0, 1.0, 0.0, 0.0),
      Array(0.0, 1.0, 4.0, 1.0, 0.0),
      Array(0.0, 0.0, 1.0, 4.0, 1.0),
      Array(0.0, 0.0, 0.0, 1.0, 4.0)
    )

    val b = Array(
      Array(1.0 / 2.0),
      Array(2.0 / 3.0),
      Array(3.0 / 4.0),
      Array(4.0 / 5.0),
      Array(5.0 / 6.0)
    )

    val x = Array(39.0 / 400.0, 11.0 / 100.0, 31.0 / 240.0, 37.0 / 300.0, 71.0 / 400.0)

    println("det: " + solve(a, b))

    for (i <- 0 until 5) {
      printf("%12.8f %12.4e\n", b(i)(0), b(i)(0) - x(i))
    }
  }
}
