object JohnsonTrotter extends App {

  private def perm(n: Int): Unit = {
    val p = new Array[Int](n) // permutation
    val pi = new Array[Int](n) // inverse permutation
    val dir = new Array[Int](n) // direction = +1 or -1

    def perm(n: Int, p: Array[Int], pi: Array[Int], dir: Array[Int]): Unit = {
      if (n >= p.length) for (aP <- p) print(aP)
      else {
        perm(n + 1, p, pi, dir)
        for (i <- 0 until n) { // swap
          printf("   (%d %d)\n", pi(n), pi(n) + dir(n))
          val z = p(pi(n) + dir(n))
          p(pi(n)) = z
          p(pi(n) + dir(n)) = n
          pi(z) = pi(n)
          pi(n) = pi(n) + dir(n)
          perm(n + 1, p, pi, dir)
        }
        dir(n) = -dir(n)
      }
    }

    for (i <- 0 until n) {
      dir(i) = -1
      p(i) = i
      pi(i) = i
    }
    perm(0, p, pi, dir)
    print("   (0 1)\n")
  }

  perm(4)

}
