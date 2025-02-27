object Pancake {
  def pancake(n: Int): Int = {
    var gap = 2
    var sum = 2
    var adj = -1

    while (sum < n) {
      adj += 1
      gap = 2 * gap - 1
      sum += gap
    }

    n + adj
  }

  def main(args: Array[String]): Unit = {
    for (i <- 0 until 4) {
      for (j <- 1 until 6) {
        val n = 5 * i + j
        print(f"p($n%2d) = ${pancake(n)}%2d  ")
      }
      println()
    }
  }
}
