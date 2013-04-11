  def hailstone(n: Int): Stream[Int] =
    n #:: {
      if (n == 1) Stream.empty
      else hailstone(if (n % 2 == 0) n / 2 else n * 3 + 1)
    }

  def main(args: Array[String]) {
    println(hailstone(27).toList)
    val (n, len) = (1 to 100000).map(n => (n, hailstone(n).length)).maxBy(_._2)
    println("value=" + n + "  len=" + len)
  }
