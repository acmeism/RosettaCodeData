import scala.annotation.tailrec

object Hickerson extends App {

  def almostInteger(n: Int): Boolean = {
    def ln2 = BigDecimal("0.69314718055994530941723212145818")

    def div: BigDecimal = ln2.pow(n + 1) * 2

    def factorial(num: Int): Long = {
      @tailrec
      def accumulated(acc: Long, n: Long): Long =
        if (n <= 0) acc else accumulated(acc * n, n - 1)

      accumulated(1, num)
    }

    ((BigDecimal(factorial(n)) / div * 10).toBigInt() % 10).toString.matches("0|9")
  }

  val aa = (1 to 17).map(n => n -> almostInteger(n))

  println(s"Function h(n) gives a almost integer with a n of ${aa.filter(_._2).map(_._1).mkString(", ")}.")
  println(s"While h(n) gives NOT an almost integer with a n of ${aa.filter(!_._2).map(_._1).mkString(", ")}.")

}
