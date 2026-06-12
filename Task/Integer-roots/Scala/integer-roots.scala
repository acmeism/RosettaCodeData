import scala.annotation.tailrec

object IntegerRoots extends App {

  println("3rd integer root of 8 = " + iRoot(8, 3))

  println("3rd integer root of 9 = " + iRoot(9, 3))

  val result = iRoot(BigInt(100).pow(2000) * BigInt(2), 2)
  println(s"All ${result.toString.length} digits of the square root of 2: \n$result")

  private def iRoot(base: BigInt, degree: Int): BigInt = {
    require(base >= 0 && degree > 0,
      "Base has to be non-negative while the degree must be positive.")

    val (n1, n2) = (degree - 1, BigInt(degree))
    val d = (n1 + base) / n2

    @tailrec
    def loop(c: BigInt, d: BigInt, e: BigInt): BigInt = {
      if (c == d || c == e) if (d < e) d else e
      else loop(d, e, (n1 * e + (base / e.pow(n1))) / n2)
    }

    loop(1, (n1 + base) / n2, (n1 * d + (base / d.pow(n1))) / n2)
  }

}
