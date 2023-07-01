object ButterworthFilter extends App {
  private def filter(a: Vector[Double],
                     b: Vector[Double],
                     signal: Vector[Double]): Vector[Double] = {

    @scala.annotation.tailrec
    def outer(i: Int, acc: Vector[Double]): Vector[Double] = {
      if (i >= signal.length) acc
      else {
        @scala.annotation.tailrec
        def inner0(j: Int, tmp: Double): Double = if (j >= b.length) tmp
        else if ((i - j) >= 0) inner0(j + 1, tmp + b(j) * signal(i - j)) else inner0(j + 1, tmp)

        @scala.annotation.tailrec
        def inner1(j: Int, tmp: Double): Double = if (j >= a.length) tmp
        else if (i - j >= 0) inner1(j + 1, tmp - a(j) * acc(i - j)) else inner1(j + 1, tmp)

        outer(i + 1, acc :+ inner1(1, inner0(0, 0D)) / a(0))
      }
    }

    outer(0, Vector())
  }

  filter(Vector[Double](1, -2.77555756e-16, 3.33333333e-01, -1.85037171e-17),
    Vector[Double](0.16666667, 0.5, 0.5, 0.16666667),
    Vector[Double](
      -0.917843918645, 0.141984778794, 1.20536903482, 0.190286794412, -0.662370894973,
      -1.00700480494, -0.404707073677, 0.800482325044, 0.743500089861, 1.01090520172,
      0.741527555207, 0.277841675195, 0.400833448236, -0.2085993586, -0.172842103641,
      -0.134316096293, 0.0259303398477, 0.490105989562, 0.549391221511, 0.9047198589)
  ).grouped(5)
    .map(_.map(x => f"$x% .8f"))
    .foreach(line => println(line.mkString(" ")))

}
