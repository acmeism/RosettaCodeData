object Feigenbaum1 extends App {
  val (max_it, max_it_j) = (13, 10)
  var (a1, a2, d1, a) = (1.0, 0.0, 3.2, 0.0)

  println(" i       d")
  var i: Int = 2
  while (i <= max_it) {
    a = a1 + (a1 - a2) / d1
    for (_ <- 0 until max_it_j) {
      var (x, y) = (0.0, 0.0)
      for (_ <- 0 until 1 << i) {
        y = 1.0 - 2.0 * y * x
        x = a - x * x
      }
      a -= x / y
    }
    val d: Double = (a1 - a2) / (a - a1)
    printf("%2d    %.8f\n", i, d)
    d1 = d
    a2 = a1
    a1 = a
    i += 1
  }

}
