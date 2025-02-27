object PancakeNumbers extends App:

  private def pancake(n: Int): Int =
    var gap = 2
    var sum = 2
    var adj = -1

    while (sum < n) {
      adj += 1
      gap = gap * 2 - 1
      sum += gap
    }

    n + adj

  private def formatPancakeNumbers(maxN: Int, perRow: Int): List[String] =
    (1 to maxN).toList
      .grouped(perRow)
      .map { group =>
        group.map(n => f"p($n%2d) = ${pancake(n)}%2d").mkString("  ")
      }
      .toList

  private def runPancakeNumbers(): Unit =
    val maxN = 20
    val formattedOutput = formatPancakeNumbers(maxN, perRow = 5)
    formattedOutput.foreach(println)

  runPancakeNumbers()
