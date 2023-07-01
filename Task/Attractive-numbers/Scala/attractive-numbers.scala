object AttractiveNumbers extends App {
  private val max = 120
  private var count = 0

  private def nFactors(n: Int): Int = {
    @scala.annotation.tailrec
    def factors(x: Int, f: Int, acc: Int): Int =
      if (f * f > x) acc + 1
      else
        x % f match {
          case 0 => factors(x / f, f, acc + 1)
          case _ => factors(x, f + 1, acc)
        }

    factors(n, 2, 0)
  }

  private def ls: Seq[String] =
    for (i <- 4 to max;
         n = nFactors(i)
         if n >= 2 && nFactors(n) == 1 // isPrime(n)
         ) yield f"$i%4d($n)"

  println(f"The attractive numbers up to and including $max%d are: [number(factors)]\n")
  ls.zipWithIndex
    .groupBy { case (_, index) => index / 20 }
    .foreach { case (_, row) => println(row.map(_._1).mkString) }
}
