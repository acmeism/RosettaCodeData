object MagicSquareDoublyEven extends App {
  private val n = 8

  private def magicSquareDoublyEven(n: Int): Array[Array[Int]] = {
    require(n >= 4 || n % 4 == 0, "Base must be a positive multiple of 4.")

    // pattern of count-up vs count-down zones
    val (bits, mult, result, size) = (38505, n / 4, Array.ofDim[Int](n, n), n * n)
    var i = 0

    for (r <- result.indices; c <- result(0).indices) {
      def bitPos = c / mult + (r / mult) * 4

      result(r)(c) = if ((bits & (1 << bitPos)) != 0) i + 1 else size - i
      i += 1
    }
    result
  }

  magicSquareDoublyEven(n).foreach(row => println(row.map(x => f"$x%2s ").mkString))
  println(f"---%nMagic constant: ${(n * n + 1) * n / 2}%d")

}
