object PerfectShuffle extends App {
  private def sizes = Seq(8, 24, 52, 100, 1020, 1024, 10000)

  private def perfectShuffle(size: Int): Int = {
    require(size % 2 == 0, "Card deck must be even")

    val (half, a) = (size / 2, Array.range(0, size))
    val original = a.clone
    var count = 1
    while (true) {
      val aa = a.clone
      for (i <- 0 until half) {
        a(2 * i) = aa(i)
        a(2 * i + 1) = aa(i + half)
      }
      if (a.deep == original.deep) return count
      count += 1
    }
    0
  }

  for (size <- sizes) println(f"$size%5d : ${perfectShuffle(size)}%5d")

}
