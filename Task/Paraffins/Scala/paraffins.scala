object Paraffins extends App {
  val (nMax, nBranches) = (250, 4)
  val rooted, unrooted = Array.tabulate(nMax + 1)(i => if (i < 2) BigInt(1) else BigInt(0))
  val (unrooted, c) = (rooted.clone(), new Array[BigInt](nBranches))

  for (n <- 1 to nMax) {
    def tree(br: Int, n: Int, l: Int, inSum: Int, cnt: BigInt): Unit = {
      var sum = inSum
      for (b <- br + 1 to nBranches) {
        sum += n
        if (sum > nMax || (l * 2 >= sum && b >= nBranches)) return

        if (b == br + 1) c(br) = rooted(n) * cnt
        else {
          c(br) = c(br) * (rooted(n) + BigInt(b - br - 1))
          c(br) = c(br) / BigInt(b - br)
        }
        if (l * 2 < sum) unrooted(sum) = unrooted(sum) + c(br)
        if (b < nBranches) rooted(sum) = rooted(sum) + c(br)

        for (m <- n - 1 to 1 by -1) tree(b, m, l, sum, c(br))
      }
    }

    def bicenter(s: Int): Unit = if ((s & 1) == 0) {
      val halves = rooted(s / 2)
      unrooted(s) = unrooted(s) + ((halves + BigInt(1)) * halves >> 1)
    }

    tree(0, n, n, 1, BigInt(1))
    bicenter(n)
    println(f"$n%3d:  ${unrooted(n)}%s")
  }
}
