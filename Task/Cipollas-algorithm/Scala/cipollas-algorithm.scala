object CipollasAlgorithm extends App {
  private val BIG = BigInt(10).pow(50) + BigInt(151)

  println(c("10", "13"))
  println(c("56", "101"))
  println(c("8218", "10007"))
  println(c("8219", "10007"))
  println(c("331575", "1000003"))
  println(c("665165880", "1000000007"))
  println(c("881398088036", "1000000000039"))
  println(c("34035243914635549601583369544560650254325084643201", ""))

  private def c(ns: String, ps: String): Triple = {
    val (n, p) = (BigInt(ns), if (ps.isEmpty) BIG else BigInt(ps))

    // Legendre symbol, returns 1, 0 or p - 1
    def ls(a: BigInt) = a.modPow((p - BigInt(1)) / BigInt(2), p)

    // multiplication in Fp2
    def mul(aa: Point, bb: Point, omega2: BigInt) =
      new Point((aa.x * bb.x + aa.y * bb.y * omega2) % p, (aa.x * bb.y + (bb.x * aa.y)) % p)

    // Step 0, validate arguments
    if (ls(n) != BigInt(1)) new Triple(0, 0, false)
    else {
      // Step 1, find a, omega2
      var (a, flag, omega2) = (BigInt(0), true, BigInt(0))
      while (flag) {
        omega2 = (a * a + p - n) % p
        if (ls(omega2) == p - BigInt(1)) flag = false else a = a + BigInt(1)
      }

      // Step 2, compute power
      var (nn, r, s) = ((p + BigInt(1) >> 1) % p, new Point(BigInt(1), 0), new Point(a, BigInt(1)))
      while (nn > 0) {
        if ((nn & BigInt(1)) == BigInt(1)) r = mul(r, s, omega2)
        s = mul(s, s, omega2)
        nn = nn >> 1
      }
      // Step 3, check x in Fp
      if (r.y != 0) new Triple(0, 0, false)
      else // Step 5, check x * x = n
      if ((r.x * r.x) % p != n) new Triple(0, 0, false)
      else new Triple(r.x, p - r.x, true) // Step 4, solutions
    }
  }

  private class Point(val x: BigInt, val y: BigInt)

  private class Triple(val x: BigInt, val y: BigInt, val b: Boolean) {
    override def toString: String = f"($x%s, $y%s, $b%s)"
  }

}
